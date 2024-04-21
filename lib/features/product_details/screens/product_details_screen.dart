import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uniket/bloc/account/account_bloc.dart';
import 'package:uniket/bloc/chat/chat_bloc.dart';
import 'package:uniket/bloc/like/like_bloc.dart';
import 'package:uniket/bloc/sale_product/sale_product_bloc.dart';
import 'package:uniket/bloc/product/product_bloc.dart';
import 'package:uniket/bloc/seller_sale_product/seller_sale_product_bloc.dart';
import 'package:uniket/bloc/seller_sold_product/sold_product_bloc.dart';
import 'package:uniket/bloc/sold_product/sold_product_bloc.dart';
import 'package:uniket/common/routes/names.dart';
import 'package:uniket/common/widgets/full_image_gallery.dart';
import 'package:uniket/constants/global_variables.dart';
import 'package:uniket/features/account/screens/user_profile.dart';
import 'package:uniket/features/account/widgets/remove_product_dialog.dart';
import 'package:uniket/features/edit-product/edit_product.dart';
import 'package:uniket/features/product_details/screens/seller_inventory_screen.dart';
import 'package:uniket/features/product_details/screens/seller_sold_products_screen.dart';
import 'package:uniket/features/product_details/widgets/seller_other_list.dart';
import 'package:uniket/models/product.dart';
import 'package:uniket/models/user_model.dart';

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
    context
        .read<SellerSaleProductBloc>()
        .add(LoadSellerSaleProductEvent(userId: widget.product.seller.id));
    context
        .read<SellerSoldProductBloc>()
        .add(LoadSellerSoldProductEvent(userId: widget.product.seller.id));
  }

  CarouselSlider _buildCarouselSlider() {
    return CarouselSlider(
      carouselController: CarouselController(),
      items: widget.product.images
          .asMap()
          .entries
          .map((entry) => Builder(
                builder: (BuildContext context) {
                  String image = entry.value; // Access image URL
                  return GestureDetector(
                    onTap: () => _openGallery(context, entry.key),
                    child: Hero(
                      tag: "product-picture-${widget.product.id}",
                      child: CachedNetworkImage(
                        cacheManager: GlobalVariables.customCacheManager,
                        imageUrl: image,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.4,
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
      options: CarouselOptions(
        viewportFraction: 1,
        height: 400,
        pageSnapping: true,
        onPageChanged: (index, reason) {
          if (index < widget.product.images.length) {
            setState(() {
              currentIndex = index;
            });
          }
        },
      ),
    );
  }

  void _openGallery(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: widget.product.images,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: initialIndex,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
                        widget.product.seller.profileImage == null
                            ? const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 20,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                  widget.product.seller.profileImage!,
                                ),
                                radius: 20,
                                backgroundColor:
                                    Colors.grey, // Placeholder color
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                  child: RichText(
                    text: TextSpan(
                        text: 'Where to meet: ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        children: [
                          TextSpan(
                            text: widget.product.location,
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                  child: Text(widget.product.description),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  height: 4,
                  color: Colors.black12,
                  indent: 8,
                  endIndent: 8,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // This will space out the children to the start and end of the row.
                    children: [
                      Text(
                        'Seller\'s Other Products',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellerProductsScreen(
                                user: widget.product.seller,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                ),

                //TODO: Add GridView for Seller's other products
                BlocBuilder<SellerSaleProductBloc, SellerSaleProductState>(
                  builder: (context, state) {
                    if (state is LoadingSellerSaleProductState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LoadedSellerSaleProductState) {
                      return SellerOtherProductsGrid(
                        otherProducts: state.sellerProduct,
                      );
                    }
                    return const SellerOtherProductsGrid(otherProducts: []);
                  },
                ),
              ],
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
        ],
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
            Navigator.pushNamed(context, AppRoutes.chatPage, arguments: {
              "seller": state.chatRooms.last.seller,
              "chatRoom": state.chatRooms.last
            });
          }
        },
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.product.seller.id == currentUser.id
                  ? const SizedBox()
                  : _buildLikeButton(),
              _buildPriceText(widget.product.price),
              widget.product.seller.id == currentUser.id
                  ? SizedBox(
                      child: widget.product.status == 'On Sale'
                          ? Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProductScreen(
                                          product: widget.product),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.edit_note_sharp,
                                    color: GlobalVariables.secondaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => removeProductDialog(
                                      context,
                                      'Confirm Deletion',
                                      'Are you sure you want to delete this product?',
                                      Icons.delete_forever_outlined, () {
                                    context.read<ProductBloc>().add(
                                        DeleteProductEvent(
                                            productId: widget.product.id));
                                    if (widget.product.status == 'Sold') {
                                      context.read<SoldProductBloc>().add(
                                            DeleteSoldProductEvent(
                                              product: widget.product,
                                            ),
                                          );
                                    } else {
                                      context.read<OnSaleProductBloc>().add(
                                            DeleteOnSaleProductEvent(
                                              product: widget.product,
                                            ),
                                          );
                                    }
                                    Navigator.pop(context);
                                  }),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
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
                                      'Confirm Deletion',
                                      'Are you sure you want to delete this product?',
                                      Icons.delete_forever_outlined, () {
                                    context.read<ProductBloc>().add(
                                        DeleteProductEvent(
                                            productId: widget.product.id));
                                    Navigator.pop(context);
                                  }),
                                  icon: const Icon(
                                    Icons.delete_forever_outlined,
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

  Widget _buildLikeButton() {
    return BlocBuilder<LikeBloc, LikeState>(
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
            if (state is LikeLoading ||
                state is LikeRemoving ||
                state is LikeAdding)
              {}
            else
              {
                if (isLikeProduct)
                  {
                    context.read<LikeBloc>().add(RemoveLikeEvent(
                          product: widget.product,
                          user: context.read<AccountBloc>().state.account.user,
                        )),
                  }
                else
                  {
                    context.read<LikeBloc>().add(AddLikeEvent(
                          product: widget.product,
                          user: context.read<AccountBloc>().state.account.user,
                        ))
                  }
              }
          },
        );
      },
    );
  }

  Widget _buildChatAndFavoriteButtons(
      ChatBlocState state, Product product, BuildContext context) {
    return TextButton(
      onPressed: () => {
        context.read<ChatBloc>().add(CreateChatRoomEvent(
              buyer: context.read<AccountBloc>().state.account.user,
              seller: widget.product.seller,
              productId: widget.product.id,
              productName: widget.product.name,
            ))
      },
      style:
          TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
      child: state is CreatingChatRoomState
          ? const CircularProgressIndicator()
          : const Text('Chat', style: TextStyle(color: Colors.white)),
    );
  }
}
