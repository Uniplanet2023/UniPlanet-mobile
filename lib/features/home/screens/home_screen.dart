import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet/bloc/free_product/free_product_bloc.dart';
import 'package:uniplanet/bloc/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/bloc/wanted_product/wanted_product_bloc.dart';
import 'package:uniplanet/common/widgets/loader.dart';
import 'package:uniplanet/features/home/widgets/build_product_box.dart';
import 'package:uniplanet/features/home/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController controller;
  const HomeScreen({
    super.key,
    required this.controller,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLoadingIndicator = false;
  bool _isFetchingMoreProducts = false;
  String choiceCheapSelected = "All Items";

  void _updateChoice(String newChoice) {
    setState(() {
      choiceCheapSelected = newChoice; // Update the state on choice change
    });
  }

  @override
  void initState() {
    super.initState();
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
        context.read<ProductBloc>().add(const LoadMoreProductEvent());
      } else if (choiceCheapSelected == "Free Products") {
        context
            .read<FreeProductBloc>()
            .add(const LoadMoreFreeProductEvent(category: "Free Products"));
      } else if (choiceCheapSelected == "Hot Items") {
        context.read<HotProductBloc>().add(const LoadMoreHotProductsEvent());
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
      body: choiceCheapSelected == "Free Products"
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
          setState(() => _showLoadingIndicator = true);
        } else if (state is ProductImageUploadedState) {
          setState(() => _showLoadingIndicator = false);
        }
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels < -100 && !_showLoadingIndicator) {
            setState(() => _showLoadingIndicator = true);
            context.read<ProductBloc>().add(const LoadProductEvent());

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

            // Other slivers
            if (_showLoadingIndicator)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50.h, top: 10.h),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is LoadingProductState) {
                  return const SliverToBoxAdapter(
                    child: Loader(),
                  );
                } else {
                  return ItemBox(
                    productList: state.productList,
                  );
                }
              },
            ),
            if (_isFetchingMoreProducts)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100.h, top: 10.h),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            if (!_isFetchingMoreProducts)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100.h,
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
                .read<FreeProductBloc>()
                .add(const LoadFreeProductEvent(category: "Free Products"));

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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.h, top: 10.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              BlocBuilder<FreeProductBloc, FreeProductState>(
                builder: (context, state) {
                  if (state is LoadingFreeProductState) {
                    return const SliverToBoxAdapter(
                      child: Loader(),
                    );
                  } else {
                    return ItemBox(
                      productList: state.productList,
                    );
                  }
                },
              ),
              if (_isFetchingMoreProducts)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100.h, top: 10.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (!_isFetchingMoreProducts)
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.h, top: 10.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              BlocBuilder<WantedProductBloc, WantedProductState>(
                builder: (context, state) {
                  if (state is LoadingFreeProductState) {
                    return const SliverToBoxAdapter(
                      child: Loader(),
                    );
                  } else {
                    return ItemBox(
                      productList: state.productList,
                    );
                  }
                },
              ),
              if (_isFetchingMoreProducts)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100.h, top: 10.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (!_isFetchingMoreProducts)
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

  BlocListener<HotProductBloc, HotProductState> hotItems(BuildContext context) {
    return BlocListener<HotProductBloc, HotProductState>(
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
            context.read<HotProductBloc>().add(const LoadHotProductsEvent());

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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.h, top: 10.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              BlocBuilder<HotProductBloc, HotProductState>(
                builder: (context, state) {
                  if (state is LoadingHotProductState) {
                    return const SliverToBoxAdapter(
                      child: Loader(),
                    );
                  } else {
                    return ItemBox(
                      productList: state.hotProducts,
                    );
                  }
                },
              ),
              if (_isFetchingMoreProducts)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100.h, top: 10.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (!_isFetchingMoreProducts)
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
