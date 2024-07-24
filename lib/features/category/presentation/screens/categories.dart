import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/category/presentation/blocs/category/category_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/free_product/free_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/product/product_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/loader.dart';
import 'package:uniplanet/features/category/presentation/widget/category_header.dart';
import 'package:uniplanet/features/home/widgets/build_product_box.dart';

class CategoriesPage extends StatefulWidget {
  final ScrollController controller;
  final String category;
  const CategoriesPage({
    super.key,
    required this.controller,
    required this.category,
  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool showLoadingIndicator = false;
  bool isFetchingMoreProducts = false;

  void scrollListener() {
    if (widget.controller.position.pixels >=
            widget.controller.position.maxScrollExtent &&
        !isFetchingMoreProducts) {
      // User has reached the end, fetch more products
      setState(() => isFetchingMoreProducts = true);
      // Simulate fetching more products with a delay
      if (widget.category == 'Hot Products') {
        if (getIt<HotProductBloc>().state is LoadedHotProductState) {
          getIt<HotProductBloc>().add(const LoadMoreHotProductsEvent());
        }
      } else if (getIt<CategoryBloc>().state is LoadedCategoryState) {
        context
            .read<CategoryBloc>()
            .add(LoadMoreCategoryEvent(category: widget.category));
      }

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => isFetchingMoreProducts = false);
          // You should replace the following line with the actual code to fetch more products
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(scrollListener); // Listen to scroll events
    if (widget.category != 'Hot Products' &&
        widget.category != 'Free Products') {
      getIt<CategoryBloc>().add(LoadCategoryEvent(category: widget.category));
    } else {
      if (widget.category == 'Free Products') {
        // _createRewardedAd();
        // _createUnterstitialAd();
      }
    }
  }

  //

  @override
  void dispose() {
    widget.controller.removeListener(scrollListener); // Remove the listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductUploadedState) {
            setState(() => showLoadingIndicator = true);
          } else if (state is ProductUploadSuccessState) {
            setState(() => showLoadingIndicator = false);
          }
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels < -100 && !showLoadingIndicator) {
              setState(() => showLoadingIndicator = true);
              if (widget.category == 'Hot Products') {
                context
                    .read<HotProductBloc>()
                    .add(const LoadHotProductsEvent());
              }
              if (widget.category == 'Free Products') {
                context
                    .read<FreeProductBloc>()
                    .add(LoadMoreFreeProductEvent(category: widget.category));
              } else {
                context
                    .read<CategoryBloc>()
                    .add(LoadCategoryEvent(category: widget.category));
              }

              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  setState(() => showLoadingIndicator = false);
                  // Dispatch LoadProductEvent only after the delay
                }
              });
            }
            return false;
          },
          child: CustomScrollView(
            controller: widget.controller,
            slivers: <Widget>[
              CategoryHeader(
                category: widget.category,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              // Other slivers
              if (showLoadingIndicator)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50, top: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),

              widget.category == 'Hot Products'
                  ? BlocBuilder<HotProductBloc, HotProductState>(
                      builder: (context, state) {
                      if (state is LoadingHotProductState) {
                        return const SliverToBoxAdapter(
                          child: Loader(),
                        );
                      } else if (state is LoadedHotProductState ||
                          state is LoadingMoreHotProductState ||
                          state is EndHotProductState) {
                        return ItemBox(
                          productList: state.hotProducts,
                        );
                      } else {
                        return const SliverToBoxAdapter(
                          child: SizedBox(),
                        );
                      }
                    })
                  : widget.category == 'Free Products'
                      ? BlocBuilder<FreeProductBloc, FreeProductState>(
                          builder: (context, state) {
                          if (state is LoadingFreeProductState) {
                            return const SliverToBoxAdapter(
                              child: Loader(),
                            );
                          } else if (state is LoadedFreeProductState ||
                              state is LoadingMoreFreeProductState ||
                              state is EndFreeProductState) {
                            return ItemBox(
                              productList: state.productList,
                            );
                          } else {
                            return const SliverToBoxAdapter(
                              child: SizedBox(),
                            );
                          }
                        })
                      : BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                            if (state is LoadingCategoryState) {
                              return const SliverToBoxAdapter(
                                child: Loader(),
                              );
                            } else if (state is LoadedCategoryState ||
                                state is LoadingMoreCategoryState ||
                                state is EndCategoryState) {
                              return ItemBox(
                                productList: state.categoryProducts,
                              );
                            } else {
                              return const SliverToBoxAdapter(
                                child: SizedBox(),
                              );
                            }
                          },
                        ),

              if (isFetchingMoreProducts)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100, top: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (!isFetchingMoreProducts)
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
