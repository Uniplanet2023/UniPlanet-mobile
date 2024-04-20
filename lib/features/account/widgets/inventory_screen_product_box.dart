import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uniket/bloc/on_sale_product/on_sale_product_bloc.dart';
import 'package:uniket/bloc/product/product_bloc.dart';
import 'package:uniket/bloc/sold_product/sold_product_bloc.dart';
import 'package:uniket/constants/global_variables.dart';
import 'package:uniket/features/account/widgets/list_item.dart';
import 'package:uniket/features/edit-product/edit_product.dart';
import 'package:uniket/models/product.dart';
import 'package:uniket/network/repository/index.dart';

class InventoryProductBox extends StatefulWidget {
  final List<Product> productList;
  final ScrollController controller;
  final bool isLoadingMore;
  const InventoryProductBox(
      {super.key,
      required this.productList,
      required this.controller,
      required this.isLoadingMore});

  @override
  State<InventoryProductBox> createState() => _InventoryProductBoxState();
}

class _InventoryProductBoxState extends State<InventoryProductBox> {
  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index < widget.productList.length) {
              final product = widget.productList[index];

              return Slidable(
                enabled: widget.productList[index].seller.id ==
                    AuthRepository.userId,
                key: ValueKey("${product.id}_${product.status}"),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      if (widget.productList[index].status == 'Sold') {
                        context.read<SoldProductBloc>().add(
                              DeleteSoldProductEvent(
                                product: widget.productList[index],
                              ),
                            );
                      } else if (widget.productList[index].status ==
                          'On Sale') {
                        context.read<OnSaleProductBloc>().add(
                              DeleteOnSaleProductEvent(
                                product: widget.productList[index],
                              ),
                            );
                      }
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
                  children: [
                    SlidableAction(
                      onPressed: (_) => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(
                                product: widget.productList[index]),
                          ),
                        )
                      },
                      icon: Icons.edit,
                      label: 'Edit',
                      backgroundColor: GlobalVariables.secondaryColor,
                    ),
                    SlidableAction(
                      onPressed: (_) async => {
                        context.read<ProductBloc>().add(DeleteProductEvent(
                            productId: widget.productList[index].id)),
                        widget.productList.removeAt(index),
                      },
                      icon: Icons.delete,
                      label: 'Remove',
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
                child: ListItem(product: product),
              );
            } else {
              return widget.isLoadingMore
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }
          },
          // 40 list items
          childCount:
              widget.productList.length + (widget.isLoadingMore ? 1 : 0),
        ),
      ),
    );
  }
}
