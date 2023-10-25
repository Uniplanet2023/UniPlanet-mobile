import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/chat/screens/chat_screen.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/features/search/screens/search_screen.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double avgRating = 0;
  double myRating = 0;
  final int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      // if (widget.product.rating![i].userId ==
      //     Provider.of<UserProvider>(context, listen: false).user.id) {
      //   myRating = widget.product.rating![i].rating;
      // }
    }

    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToChatScreen() async {
    context.read<ChatBloc>().add(CreateChatRoomEvent(widget.product.sellerId));
    Navigator.pushNamed(context, ChatScreen.routeName,
        arguments: widget.product.sellerId);
  }

  void navigateToback(BuildContext context) {
    Navigator.pop(context);
  }

  void addToLikes() {
    UserRepository().addToLikes(
      context: context,
      product: widget.product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: widget.product.images.map(
                (image) {
                  return Builder(
                    builder: (BuildContext context) => CachedNetworkImage(
                      cacheManager: GlobalVariables.customCacheManager,
                      imageUrl: image,
                      key: UniqueKey(),
                      fit: BoxFit.contain,
                      height: 400,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black12,
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 80,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 400,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Fixed Price: ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\$${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => navigateToback(context),
          ),
          RichText(
            text: TextSpan(
              text: 'Price: ',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '\$${widget.product.price}',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(children: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
            TextButton(
              onPressed: navigateToChatScreen,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    GlobalVariables.secondaryColor),
              ),
              child: const Text('Chat',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ]),
        ],
      )),
    );
  }
}
