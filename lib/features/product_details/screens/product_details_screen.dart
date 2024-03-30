import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_state.dart';
import 'package:uniplanet_mobile/bloc/like/like_bloc.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/account/screens/user_profile.dart';
import 'package:uniplanet_mobile/features/account/widgets/remove_product_dialog.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late User currentUser;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentUser = context.read<AccountBloc>().state.account.user;
  }

  CarouselSlider _buildCarouselSlider() {
    return CarouselSlider(
      items: widget.product.images
          .asMap()
          .entries
          .map((entry) => Builder(
                builder: (BuildContext context) {
                  // int index = entry.key; // Access index for unique tag
                  String image = entry.value; // Access image URL
                  return Hero(
                    tag: "product-picture-${widget.product.id}",
                    child: CachedNetworkImage(
                      cacheManager: GlobalVariables.customCacheManager,
                      imageUrl: image,
                      fit: BoxFit.fill,
                      height: 400,
                      placeholder: (_, __) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.error, color: Colors.red, size: 80),
                    ),
                  );
                },
              ))
          .toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        height: 400,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
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
            Center(
              child: DotsIndicator(
                dotsCount: widget.product.images.length,
                position: currentIndex,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserProfileScreen(user: widget.product.seller),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                      radius: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.product.seller.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              height: 4,
              color: Colors.black12,
              indent: 8,
              endIndent: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              child: RichText(
                text: TextSpan(
                    text: "${widget.product.category} . ",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat.yMd()
                            .add_jm()
                            .format(widget.product.createdAt),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              child: RichText(
                text: const TextSpan(
                    text: 'Where to meet: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [
                      TextSpan(
                        text: 'Yang hall',
                        style: TextStyle(
                          fontSize: 16,
                          color: GlobalVariables.secondaryColor,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              child: Text(
                'Description:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
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
        text: 'Price: ',
        style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis),
        children: [
          TextSpan(
            text: (price == 0) ? "Free" : '\$$price',
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
            SocketService.instance.joinChat(state.chatRoomCreated.id,
                state.chatRoomCreated.seller.id, context);

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
                  ? SizedBox(
                      child: widget.product.status == 'onSale'
                          ? Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.price_change_outlined,
                                    color: GlobalVariables.secondaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => removeProductDialog(
                                      context,
                                      'Remove the product for the Market?',
                                      'Remove',
                                      Icons.archive_outlined,
                                      () {}),
                                  icon: const Icon(
                                    Icons.archive_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                IconButton(
                                  onPressed: () => removeProductDialog(
                                      context,
                                      'Delete the product from sale history?',
                                      'Delete',
                                      Icons.delete_forever_outlined,
                                      () {}),
                                  icon: const Icon(
                                    Icons.archive_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                    )
                  : _buildChatAndFavoriteButtons(
                      state, widget.product, context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatAndFavoriteButtons(
      ChatBlocState state, Product product, BuildContext context) {
    return Row(
      children: [
        BlocBuilder<LikeBloc, LikeState>(
          builder: (context, state) {
            bool isLikeProduct = false;
            for (var element in state.likeProduct) {
              if (element.id == widget.product.id) {
                isLikeProduct = true;
                break;
              }
            }
            return IconButton(
              icon: isLikeProduct
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border),
              onPressed: () => {
                isLikeProduct
                    ? context.read<LikeBloc>().add(RemoveLikeEvent(
                          product: widget.product,
                          user: context.read<AccountBloc>().state.account.user,
                        ))
                    : context.read<LikeBloc>().add(AddLikeEvent(
                          product: widget.product,
                          user: context.read<AccountBloc>().state.account.user,
                        ))
              },
            );
          },
        ),
        TextButton(
          onPressed: () => {
            context.read<ChatBloc>().add(CreateChatRoomEvent(
                  buyer: context.read<AccountBloc>().state.account.user,
                  seller: widget.product.seller,
                  productId: widget.product.id,
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
