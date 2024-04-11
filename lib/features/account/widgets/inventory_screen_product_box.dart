import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uniplanet_mobile/bloc/like/like_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
import 'package:uniplanet_mobile/constants/number_formatter.dart';
import 'package:uniplanet_mobile/constants/price_formatter.dart';
import 'package:uniplanet_mobile/constants/time_formatter.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/common/widgets/loader.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/account/widgets/list_item.dart';
import 'package:uniplanet_mobile/features/account/widgets/remove_product_dialog.dart';
import 'package:uniplanet_mobile/features/edit-product/edit_product.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/network/repository/index.dart';

class InventoryProductBox extends StatefulWidget {
  final List<Product> productList;
  const InventoryProductBox({super.key, required this.productList});

  @override
  State<InventoryProductBox> createState() => _InventoryProductBoxState();
}

class _InventoryProductBoxState extends State<InventoryProductBox> {
  @override
  Widget build(BuildContext context) {
    bool confirm;
    return widget.productList == []
        ? const Loader()
        : SlidableAutoCloseBehavior(
            closeWhenOpened: true,
            child: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final product = widget.productList[index];
                  return Slidable(
                    enabled: widget.productList[index].seller.id ==
                        AuthRepository.userId,
                    key: Key(product.id),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(
                        onDismissed: () {
                          widget.productList[index].status == 'Sold'
                              ? widget.productList[index].status = 'On Sale'
                              : widget.productList[index].status = 'Sold';
                          context.read<ProductBloc>().add(UpdateProductEvent(
                              product: widget.productList[index]));
                        },
                      ),
                      children: [
                        widget.productList[index].status == 'Sold'
                            ? SlidableAction(
                                onPressed: (_) => {},
                                icon: Icons.replay_outlined,
                                label: 'Mark as On Sale',
                                backgroundColor: Colors.blue,
                              )
                            : SlidableAction(
                                onPressed: (_) => {},
                                icon: Icons.done,
                                label: 'Mark as Sold',
                                backgroundColor: Colors.green,
                              )
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        widget.productList.removeAt(index);
                        context.read<ProductBloc>().add(DeleteProductEvent(
                            productId: widget.productList[index].id));
                      }),
                      children: [
                        SlidableAction(
                          onPressed: (_) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductScreen(
                                  productImages: product.images,
                                  productName: product.name,
                                  productCategory: product.category,
                                  productPrice: product.price,
                                  productDescription: product.description,
                                  selectedLocation: product.location,
                                  productId: product.id,
                                ),
                              ),
                            )
                          },
                          icon: Icons.edit,
                          label: 'Edit',
                          backgroundColor: GlobalVariables.secondaryColor,
                        ),
                        SlidableAction(
                          onPressed: (_) async => {
                            confirm = await removeProductDialog(
                                    context,
                                    'Delete the product from sale history?',
                                    'Delete',
                                    Icons.delete_forever_outlined,
                                    () {}) ??
                                false,
                            if (confirm && context.mounted)
                              context.read<ProductBloc>().add(
                                  DeleteProductEvent(
                                      productId: widget.productList[index].id)),
                          },
                          icon: Icons.delete,
                          label: 'Remove',
                          backgroundColor: Colors.red,
                        ),
                      ],
                    ),
                    child: ListItem(product: product),
                  );
                },
                // 40 list items
                childCount: widget.productList.length,
              ),
            ),
          );
  }
}
