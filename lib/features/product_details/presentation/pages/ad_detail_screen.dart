import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/entities/user_type.dart';
import 'package:uniplanet/features/common/presentation/widgets/selectable_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/home/domain/entities/advertisement.dart';
import 'package:uniplanet/features/housing/presentation/screens/full_image_page.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/features/account/presentation/screens/user_profile.dart';
import 'package:uniplanet/core/network/repository/index.dart';

class AdDetailScreen extends StatefulWidget {
  final Advertisement advertisement;
  const AdDetailScreen({super.key, required this.advertisement});

  @override
  State<AdDetailScreen> createState() => AdDetailScreenState();
}

class AdDetailScreenState extends State<AdDetailScreen> {
  late User currentUser;
  InterstitialAd? _interstitialAd;
  int currentIndex = 0;
  int availableFreeItems = 2;

  @override
  void initState() {
    super.initState();

    currentUser = getIt<AccountBloc>().state.account.user;
    // context
    //     .read<SellerSaleProductBloc>()
    //     .add(LoadSellerSaleProductEvent(userId: widget.advertisement.advertiser.id));
    // context
    //     .read<SellerSoldProductBloc>()
    //     .add(LoadSellerSoldProductEvent(userId: widget.product.seller.id));
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void shareProduct(
      BuildContext context, String productName, String productImage) async {
    // Download the image to a temporary directory
    final tempDir = await getTemporaryDirectory();
    final imagePath = '${tempDir.path}/temp_image.jpg';
    final response = await DioHelper.instance.dio.get(
      productImage,
      options: Options(responseType: ResponseType.bytes),
    );
    final file = File(imagePath);
    await file.writeAsBytes(response.data);

    // Share the image along with text
    if (Platform.isIOS || Platform.isAndroid) {
      Share.shareXFiles(
        [XFile(imagePath)],
        text:
            'Check out the product on UniPlanet: $productName on UniPlanet Market! Join our Campus Community marketplace now: https://uniplanet.shop',
      );
    } else {
      Share.share(
        'Check out the product on UniPlanet: $productName on UniPlanet Market! Join our Campus Community marketplace now: https://uniplanet.shop',
      );
    }
  }

  CarouselSlider _buildCarouselSlider(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double sliderHeight = screenHeight > 1000
        ? screenHeight * 0.6 // Height for larger screens like iPads
        : screenHeight * 0.5; // Proportional height for smaller screens

    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1,
        height: sliderHeight,
        pageSnapping: true,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          if (index < widget.advertisement.images.length) {
            setState(() {
              currentIndex = index;
            });
          }
        },
      ),
      items: widget.advertisement.images
          .asMap()
          .entries
          .map((entry) => Builder(
                builder: (BuildContext context) {
                  String image = entry.value; // Access image URL
                  return GestureDetector(
                    onTap: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(
                            imageUrls: widget.advertisement.images,
                            initialIndex: entry.key,
                          ),
                        ),
                      )
                    },
                    child: Hero(
                      tag: "product-picture-${widget.advertisement.id}",
                      child: CachedNetworkImage(
                        cacheManager: GlobalVariables.customCacheManager,
                        imageUrl: image,
                        fit: BoxFit.cover,
                        height: sliderHeight,
                        width: MediaQuery.of(context).size.width,
                        placeholder: (_, __) =>
                            // Placeholder widget while loading
                            Container(
                          color: Colors.grey, // Grey box as a placeholder
                        ),
                        errorWidget: (_, __, ___) => const Icon(Icons.error,
                            color: Colors.red, size: 80),
                      ),
                    ),
                  );
                },
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarouselSlider(context),
                widget.advertisement.images.isEmpty
                    ? const SizedBox()
                    : Center(
                        child: DotsIndicator(
                          decorator: DotsDecorator(
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
                              color: Theme.of(context).colorScheme.tertiary),
                          dotsCount: widget.advertisement.images.length,
                          position: currentIndex,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                              user: widget.advertisement.advertiser),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 20,
                              backgroundImage: widget.advertisement.advertiser
                                          .profileImage !=
                                      null
                                  ? NetworkImage(
                                      widget.advertisement.advertiser
                                          .profileImage!,
                                    )
                                  : null,
                              child: widget.advertisement.advertiser
                                          .profileImage ==
                                      null
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : const SizedBox(),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SelectableText(
                              widget.advertisement.advertiser.name,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              widget.advertisement.school,
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            widget.advertisement.advertiser.type ==
                                    getUserType(UserType.student)
                                ? Icon(
                                    Icons.verified,
                                    size: 18,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : Icon(
                                    Icons.warning_amber_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 4,
                  color: Theme.of(context).colorScheme.tertiaryFixedDim,
                  indent: 8,
                  endIndent: 8,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SelectableText(
                    widget.advertisement.adName,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                  child: RichText(
                    text: TextSpan(
                        text: "${widget.advertisement.type} . ",
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
                                .format(widget.advertisement.createdAt),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                  child: RichText(
                    text: TextSpan(
                        text: 'Where to meet: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        children: [
                          TextSpan(
                            text: widget.advertisement.location == 'Custom'
                                ? '${widget.advertisement.address}, ${widget.advertisement.city}, ${widget.advertisement.state}, ${widget.advertisement.zipCode}'
                                : widget.advertisement.location,
                            style: const TextStyle(
                              fontSize: 16,
                              color: GlobalVariables.secondaryColor,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ]),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                  child: Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16),
                    child: SelectableLinkText(
                        text: widget.advertisement.description!)),
                const SizedBox(
                  height: 30,
                ),
                Divider(
                  height: 4,
                  color: Theme.of(context).colorScheme.tertiaryFixedDim,
                  indent: 8,
                  endIndent: 8,
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment
                //         .spaceBetween, // This will space out the children to the start and end of the row.
                //     children: [
                //       SelectableText(
                //         'Seller\'s Other Products',
                //         style: TextStyle(
                //           fontSize: 20,
                //           color: Theme.of(context).colorScheme.tertiary,
                //           fontFamily: GoogleFonts.roboto().fontFamily,
                //           fontWeight: FontWeight.bold,
                //           overflow: TextOverflow.ellipsis,
                //         ),
                //       ),
                //       IconButton(
                //         onPressed: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => SellerProductsScreen(
                //                 user: widget.advertisement.advertiser,
                //               ),
                //             ),
                //           );
                //         },
                //         icon: const Icon(Icons.arrow_forward_ios_rounded),
                //       ),
                //     ],
                //   ),
                // ),

                // Add GridView for Seller's other products
                // BlocBuilder<SellerSaleProductBloc, SellerSaleProductState>(
                //   builder: (context, state) {
                //     if (state is LoadingSellerSaleProductState) {
                //       return const Center(child: CircularProgressIndicator());
                //     } else if (state is LoadedSellerSaleProductState) {
                //       return SellerOtherProductsGrid(
                //         otherProducts: state.sellerProduct,
                //       );
                //     }
                //     return const SellerOtherProductsGrid(otherProducts: []);
                //   },
                // ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height:
                100, // Adjust the height to control the extent of the gradient shadow
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black
                        .withOpacity(0.5), // More opacity for more shadow
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent, // AppBar transparent
              elevation: 0, // No shadow
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width * 0.75,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent, // AppBar transparent
              elevation: 0, // No shadow
              leading: IconButton(
                icon: const Icon(
                  Icons.ios_share,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  shareProduct(context, widget.advertisement.adName,
                      widget.advertisement.images.first);
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width * 0.85,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent, // AppBar transparent
              elevation: 0, // No shadow
              leading: IconButton(
                icon: const Icon(
                  Icons.menu_sharp,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  // showOptions(
                  //     context, widget.advertisement.advertiser, widget.product.id);
                },
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: _buildBottomAppBar(),
    );
  }

//   Widget _buildPriceText(double price) {
//     return Expanded(
//       child: RichText(
//         text: TextSpan(
//           text: 'Price: ',
//           style: TextStyle(
//               fontSize: 16,
//               color: Theme.of(context).colorScheme.tertiary,
//               fontWeight: FontWeight.bold,
//               overflow: TextOverflow.ellipsis),
//           children: [
//             TextSpan(
//               text: (price == 0) ? "Free" : '\$$price',
//               style: const TextStyle(
//                   fontSize: 22,
//                   color: Colors.red,
//                   fontWeight: FontWeight.w500,
//                   overflow: TextOverflow.ellipsis),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   BottomAppBar _buildBottomAppBar() {
//     return BottomAppBar(
//       child: BlocConsumer<ChatBloc, ChatBlocState>(
//         listener: (context, state) {
//           if (state is CreatedChatRoomState) {
//             // buyer perspective
//             CreatedChatRoomState createdState = state;
//             Navigator.pushNamed(context, AppRoutes.chatPage, arguments: {
//               "seller": createdState.chatRoomCreated.seller,
//               "chatRoom": createdState.chatRoomCreated
//             });
//           } else if (state is AddedChatRoomState) {
//             //seller perspective
//             AddedChatRoomState addedChatRoomState = state;
//             Navigator.pushNamed(context, AppRoutes.chatPage, arguments: {
//               "seller": addedChatRoomState.chatRoomCreated.buyer,
//               "chatRoom": addedChatRoomState.chatRoomCreated,
//             });
//           }
//         },
//         builder: (context, state) {
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               widget.advertisement.advertiser.id == currentUser.id
//                   ? const SizedBox()
//                   : _buildLikeButton(),
//               _buildPriceText(widget.product.price),
//               widget.advertisement.advertiser.id == currentUser.id
//                   ? SizedBox(
//                       child: widget.product.status == 'On Sale'
//                           ? Row(
//                               children: [
//                                 IconButton(
//                                   onPressed: () => Navigator.pushNamed(
//                                     context,
//                                     AppRoutes.editProductPage,
//                                     arguments: widget.product,
//                                   ),
//                                   icon: const Icon(
//                                     Icons.edit_note_sharp,
//                                     color: GlobalVariables.secondaryColor,
//                                   ),
//                                 ),
//                                 IconButton(
//                                   onPressed: () => removeProductDialog(
//                                       context,
//                                       'Confirm Deletion',
//                                       'Are you sure you want to delete this product?',
//                                       Icons.delete_forever_outlined, () {
//                                     getIt<ProductBloc>().add(DeleteProductEvent(
//                                         productId: widget.product.id));
//                                     if (widget.product.status == 'Sold') {
//                                       getIt<SoldProductBloc>().add(
//                                         DeleteSoldProductEvent(
//                                           product: widget.product,
//                                         ),
//                                       );
//                                     } else {
//                                       getIt<OnSaleProductBloc>().add(
//                                         DeleteOnSaleProductEvent(
//                                           product: widget.product,
//                                         ),
//                                       );
//                                     }
//                                     Navigator.pop(context);
//                                   }),
//                                   icon: const Icon(
//                                     Icons.delete_outline_rounded,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Row(
//                               children: [
//                                 IconButton(
//                                   onPressed: () => removeProductDialog(
//                                       context,
//                                       'Confirm Deletion',
//                                       'Are you sure you want to delete this product?',
//                                       Icons.delete_forever_outlined, () {
//                                     getIt<ProductBloc>().add(DeleteProductEvent(
//                                         productId: widget.product.id));
//                                     Navigator.pop(context);
//                                   }),
//                                   icon: const Icon(
//                                     Icons.delete_forever_outlined,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     )
//                   : chatButton(
//                       state, widget.product, context, availableFreeItems),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildLikeButton() {
//     return BlocBuilder<LikeBloc, LikeState>(
//       builder: (context, state) {
//         bool isLikeProduct = false;
//         for (var element in state.likeProduct) {
//           if (element.id == widget.product.id) {
//             isLikeProduct = true;
//             break;
//           }
//         }

//         return IconButton(
//           icon: isLikeProduct
//               ? const Icon(Icons.favorite, color: Colors.red)
//               : const Icon(Icons.favorite_border),
//           onPressed: () => {
//             if (state is LikeLoading ||
//                 state is LikeRemoving ||
//                 state is LikeAdding)
//               {}
//             else
//               {
//                 if (isLikeProduct)
//                   {
//                     getIt<LikeBloc>().add(RemoveLikeEvent(
//                       product: widget.product,
//                       user: getIt<AccountBloc>().state.account.user,
//                     )),
//                   }
//                 else
//                   {
//                     getIt<LikeBloc>().add(AddLikeEvent(
//                       product: widget.product,
//                       user: getIt<AccountBloc>().state.account.user,
//                     ))
//                   }
//               }
//           },
//         );
//       },
//     );
//   }
// }

// void showOptions(BuildContext context, User client, String productId) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return Wrap(
//         children: <Widget>[
//           ListTile(
//             leading: const Icon(Icons.report),
//             title: const Text('Report'),
//             onTap: () {
//               Navigator.of(context).pop();
//               // Navigate to the report page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ReportUserPage(
//                     client: client, // Pass the appropriate user object
//                     productId: productId, // Pass the appropriate product ID
//                   ),
//                 ),
//               );
//             },
//           ),
//           // ListTile(
//           //   leading: const Icon(Icons.hide_source),
//           //   title: const Text("Hide this user's listing?"),
//           //   onTap: () {
//           //     Navigator.of(context).pop();
//           //     // Handle hiding the user's listing
//           //   },
//           // ),
//           ListTile(
//             leading: const Icon(Icons.cancel),
//             title: const Text('Cancel'),
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           // ListTile(
//           //   leading: const Icon(Icons.block),
//           //   title: const Text('Block'),
//           //   onTap: () {
//           //     Navigator.of(context).pop();
//           //     // Handle blocking the user
//           //   },
//           // ),
//         ],
//       );
//     },
//   );
}
