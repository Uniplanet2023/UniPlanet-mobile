import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_state.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late User currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = context.read<AccountBloc>().state.account.user;
  }

  CarouselSlider _buildCarouselSlider() {
    return CarouselSlider(
      items: widget.product.images
          .map((image) => Builder(
                builder: (BuildContext context) {
                  return CachedNetworkImage(
                    cacheManager: GlobalVariables.customCacheManager,
                    imageUrl: image,
                    fit: BoxFit.contain,
                    height: 400,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.error, color: Colors.red, size: 80),
                  );
                },
              ))
          .toList(),
      options: CarouselOptions(viewportFraction: 1, height: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarouselSlider(),
            const Divider(height: 4, color: Colors.black12),
            Padding(
              padding: const EdgeInsets.all(8),
              child: _buildPriceText(widget.product.price),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildPriceText(double price) {
    return RichText(
      text: TextSpan(
        text: 'Fixed Price: ',
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: '\$$price',
            style: const TextStyle(
                fontSize: 22, color: Colors.red, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      child: BlocConsumer<ChatBloc, ChatBlocState>(
        listener: (context, state) {
          if (state is CreatedChatRoomState) {
            Navigator.pushNamed(context, AppRoutes.chatPage, arguments: {
              "seller": state.buyingChatRooms.last.seller,
              "chatRoom": state.buyingChatRooms.last
            });
          }
        },
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              _buildPriceText(widget.product.price),
              widget.product.seller.id == currentUser.id
                  ? const SizedBox()
                  : _buildChatAndFavoriteButtons(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatAndFavoriteButtons(ChatBlocState state) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => {},
        ),
        TextButton(
          onPressed: () => {
            context.read<ChatBloc>().add(CreateChatRoomEvent(
                  widget.product.seller.id,
                  widget.product.id,
                ))
          },
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          child: state is CreatingChatRoomState
              ? const CircularProgressIndicator()
              : const Text('Chat', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
