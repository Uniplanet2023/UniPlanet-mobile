import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/features/category/presentation/blocs/free_product/free_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/buying/wanted_product_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/product/product_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/loader.dart';
import 'package:uniplanet/features/home/presentation/blocs/advertisement/advertisement_bloc.dart';
import 'package:uniplanet/features/home/presentation/widgets/item_list.dart';
import 'package:uniplanet/features/home/presentation/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController controller; // Accept ScrollController
  const HomeScreen({
    super.key,
    required this.controller,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showUploadIndicator = false;
  bool _showLoadingIndicator = false;
  bool _isFetchingMoreProducts = false;
  String choiceCheapSelected = "All Items";

  void _updateChoice(String newChoice) {
    if (newChoice == 'Housing') {
      Navigator.pushNamed(context, AppRoutes.housingPage);
    } else if (newChoice == 'Job') {
      Navigator.pushNamed(context, AppRoutes.jobList);
    } else if (newChoice == 'Offers') {
      Navigator.pushNamed(context, AppRoutes.offerList);
    } else {
      setState(() {
        choiceCheapSelected = newChoice; // Update the state on choice change
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (getIt<ProductBloc>().state is ProductUploadingState ||
        getIt<ProductBloc>().state is ProductUploadedState) {
      _showUploadIndicator = true;
    }
    widget.controller.addListener(_scrollListener); // Listen to scroll events
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollListener); // Remove the listener
    super.dispose();
  }

  void _scrollListener() {
    if (widget.controller.position.pixels >=
            widget.controller.position.maxScrollExtent &&
        !_isFetchingMoreProducts) {
      // User has reached the end, fetch more products
      setState(() => _isFetchingMoreProducts = true);
      // Simulate fetching more products with a delay
      if (choiceCheapSelected == "All Items") {
        getIt<ProductBloc>().add(const LoadMoreProductEvent());
      } else if (choiceCheapSelected == "Free Items") {
        context
            .read<FreeProductBloc>()
            .add(const LoadMoreFreeProductEvent(category: "Free Items"));
      } else if (choiceCheapSelected == "Hot Items") {
        getIt<HotProductBloc>().add(const LoadMoreHotProductsEvent());
      } else if (choiceCheapSelected == "Buying") {
        context
            .read<WantedProductBloc>()
            .add(const LoadMoreWantedProductEvent());
      }

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isFetchingMoreProducts = false);
          // You should replace the following line with the actual code to fetch more products
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: choiceCheapSelected == "Free Items"
          ? freeItems(context)
          : choiceCheapSelected == "Hot Items"
              ? hotItems(context)
              : choiceCheapSelected == "Buying"
                  ? wantedItems(context)
                  : allItem(context),
    );
  }

  BlocListener<ProductBloc, ProductState> allItem(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductUploadedState) {
          setState(() => _showUploadIndicator = true);
        } else if (state is ProductUploadSuccessState) {
          setState(() => _showUploadIndicator = false);
        }
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels < -100 && !_showLoadingIndicator) {
            setState(() => _showLoadingIndicator = true);
            getIt<ProductBloc>().add(const LoadProductEvent());

            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() => _showLoadingIndicator = false);
                // Dispatch LoadProductEvent only after the delay
              }
            });
          }
          return false;
        },
        child: CustomScrollView(
          controller: widget.controller,
          slivers: <Widget>[
            HomeHeader(
              choiceCheapSelected: choiceCheapSelected,
              onChoiceChanged: _updateChoice,
            ),

            // Show LinearProgressIndicator at the top of the ItemBox
            if (_showUploadIndicator)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: LinearProgressIndicator(),
                ),
              ),

            // Other slivers
            if (_showLoadingIndicator)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50, top: 10),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                return BlocBuilder<AdvertisementBloc, AdvertisementState>(
                  builder: (context, adState) {
                    if (productState is LoadingProductState ||
                        adState is AdvertisementLoading) {
                      return const SliverToBoxAdapter(
                        child: Loader(),
                      );
                    } else {
                      return ItemList(
                          productList: productState.productList,
                          ads: adState.ads);
                    }
                  },
                );
              },
            ),
            if (_isFetchingMoreProducts)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100, top: 10),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            if (!_isFetchingMoreProducts)
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                ),
              ),
          ],
        ),
      ),
    );
  }

  BlocListener<FreeProductBloc, FreeProductState> freeItems(
      BuildContext context) {
    return BlocListener<FreeProductBloc, FreeProductState>(
      listener: (context, state) {},
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels < -100 && !_showLoadingIndicator) {
            setState(() => _showLoadingIndicator = true);
            context
                .read<FreeProductBloc>()
                .add(const LoadFreeProductEvent(category: "Free Items"));

            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() => _showLoadingIndicator = false);
                // Dispatch LoadProductEvent only after the delay
              }
            });
          }
          return false;
        },
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: CustomScrollView(
            controller: widget.controller,
            slivers: <Widget>[
              HomeHeader(
                choiceCheapSelected: choiceCheapSelected,
                onChoiceChanged: _updateChoice,
              ),

              // Other slivers
              if (_showLoadingIndicator)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50, top: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              BlocBuilder<FreeProductBloc, FreeProductState>(
                builder: (context, freeProductState) {
                  return BlocBuilder<AdvertisementBloc, AdvertisementState>(
                    builder: (context, adState) {
                      if (freeProductState is LoadingFreeProductState ||
                          adState is AdvertisementLoading) {
                        return const SliverToBoxAdapter(
                          child: Loader(),
                        );
                      } else {
                        return ItemList(
                          productList: freeProductState.productList,
                          ads: adState.ads,
                        );
                      }
                    },
                  );
                },
              ),
              if (_isFetchingMoreProducts)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100, top: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (!_isFetchingMoreProducts)
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  BlocListener<WantedProductBloc, WantedProductState> wantedItems(
      BuildContext context) {
    return BlocListener<WantedProductBloc, WantedProductState>(
      listener: (context, state) {
        // if (state is ProductUploadedState) {
        //   setState(() => _showLoadingIndicator = true);
        // } else if (state is ProductImageUploadedState) {
        //   setState(() => _showLoadingIndicator = false);
        // }
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels < -100 && !_showLoadingIndicator) {
            setState(() => _showLoadingIndicator = true);
            context
                .read<WantedProductBloc>()
                .add(const LoadWantedProductEvent());

            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() => _showLoadingIndicator = false);
                // Dispatch LoadProductEvent only after the delay
              }
            });
          }
          return false;
        },
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: CustomScrollView(
            controller: widget.controller,
            slivers: <Widget>[
              HomeHeader(
                choiceCheapSelected: choiceCheapSelected,
                onChoiceChanged: _updateChoice,
              ),

              // Other slivers
              if (_showLoadingIndicator)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50, top: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              BlocBuilder<WantedProductBloc, WantedProductState>(
                builder: (context, wantedProductState) {
                  return BlocBuilder<AdvertisementBloc, AdvertisementState>(
                    builder: (context, adState) {
                      if (wantedProductState is LoadingWantedProductState ||
                          adState is AdvertisementLoading) {
                        return const SliverToBoxAdapter(
                          child: Loader(),
                        );
                      } else {
                        return ItemList(
                          productList: wantedProductState.productList,
                          ads: adState.ads,
                        );
                      }
                    },
                  );
                },
              ),
              if (_isFetchingMoreProducts)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100, top: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (!_isFetchingMoreProducts)
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  BlocListener<HotProductBloc, HotProductState> hotItems(BuildContext context) {
    return BlocListener<HotProductBloc, HotProductState>(
      listener: (context, state) {
// if (state is ProductUploadedState) {
//   setState(() => _showLoadingIndicator = true);
// } else if (state is ProductImageUploadedState) {
//   setState(() => _showLoadingIndicator = false);
// }
      },
      child: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels < -100 && !_showLoadingIndicator) {
            setState(() => _showLoadingIndicator = true);
            getIt<HotProductBloc>().add(const LoadHotProductsEvent());
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() => _showLoadingIndicator = false);
                // Dispatch LoadProductEvent only after the delay
              }
            });
          }
          return false;
        },
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: CustomScrollView(
            controller: widget.controller,
            slivers: <Widget>[
              HomeHeader(
                choiceCheapSelected: choiceCheapSelected,
                onChoiceChanged: _updateChoice,
              ),

              // Other slivers
              if (_showLoadingIndicator)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50, top: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              BlocBuilder<HotProductBloc, HotProductState>(
                builder: (context, hotProductState) {
                  return BlocBuilder<AdvertisementBloc, AdvertisementState>(
                    builder: (context, adState) {
                      if (hotProductState is LoadingHotProductState ||
                          adState is AdvertisementLoading) {
                        return const SliverToBoxAdapter(
                          child: Loader(),
                        );
                      } else {
                        return ItemList(
                          productList: hotProductState.hotProducts,
                          ads: adState.ads,
                        );
                      }
                    },
                  );
                },
              ),
              if (_isFetchingMoreProducts)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100, top: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (!_isFetchingMoreProducts)
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
