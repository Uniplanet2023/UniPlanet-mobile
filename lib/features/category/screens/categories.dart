import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/bloc/free_product/free_product_bloc.dart';
import 'package:uniplanet/bloc/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/common/widgets/loader.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/features/category/widget/category_header.dart';
import 'package:uniplanet/features/home/widgets/build_product_box.dart';
import 'package:uniplanet/network/ads/ad_mob_service.dart';

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
        if (context.read<HotProductBloc>().state is LoadedHotProductState) {
          context.read<HotProductBloc>().add(const LoadMoreHotProductsEvent());
        }
      } else if (context.read<CategoryBloc>().state is LoadedCategoryState) {
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
      context
          .read<CategoryBloc>()
          .add(LoadCategoryEvent(category: widget.category));
    } else {
      if (widget.category == 'Free Products') {
        context
            .read<FreeProductBloc>()
            .add(LoadFreeProductEvent(category: widget.category));
        _createRewardedAd();
      }
    }
  }

  _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (Ad ad) =>
                log('Ad showed full screen content.'),
            onAdDismissedFullScreenContent: (Ad ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
              ad.dispose();
              _createRewardedAd();
            },
          );
          ad.show(
            onUserEarnedReward: (ad, RewardItem reward) {
              log('User earned reward of: ${reward.amount}');
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Ad failed to load
          log('Ad failed to load: $error');
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(scrollListener); // Remove the listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductUploadedState) {
            setState(() => showLoadingIndicator = true);
          } else if (state is ProductImageUploadedState) {
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

              // Other slivers
              if (showLoadingIndicator)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.h, top: 10.h),
                    child: const Center(child: CircularProgressIndicator()),
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100.h, top: 10.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (!isFetchingMoreProducts)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100.h,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
