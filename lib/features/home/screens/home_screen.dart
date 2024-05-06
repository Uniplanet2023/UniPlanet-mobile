import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet/bloc/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/features/home/widgets/build_product_box.dart';
import 'package:uniplanet/models/product.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController controller;
  final String? category;
  const HomeScreen({
    super.key,
    required this.controller,
    this.category,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLoadingIndicator = false;
  bool _isFetchingMoreProducts =
      false; // New flag to track fetching more products

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scrollListener); // Listen to scroll events
    if (widget.category != null && widget.category != 'Hot Products') {
      context
          .read<CategoryBloc>()
          .add(LoadCategoryEvent(category: widget.category!));
    }
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
      if (widget.category == 'Hot Products') {
        if (context.read<HotProductBloc>().state is LoadedHotProductState) {
          context.read<HotProductBloc>().add(const LoadMoreHotProductsEvent());
        }
      } else if (widget.category != null) {
        if (context.read<CategoryBloc>().state is LoadedCategoryState) {
          context
              .read<CategoryBloc>()
              .add(LoadMoreCategoryEvent(category: widget.category!));
        }
      } else {
        if (context.read<ProductBloc>().state is LoadedProductState) {
          context.read<ProductBloc>().add(const LoadMoreProductEvent());
        }
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
      body: BlocListener<ProductBloc, ProductState>(
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
              if (widget.category == 'Hot Products') {
                context
                    .read<HotProductBloc>()
                    .add(const LoadHotProductsEvent());
              } else if (widget.category != null) {
                context
                    .read<CategoryBloc>()
                    .add(LoadCategoryEvent(category: widget.category!));
              } else {
                context.read<ProductBloc>().add(const LoadProductEvent());
              }

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
              SliverAppBar(
                pinned: widget.category == null ? false : true,
                snap: true,
                floating: true,
                expandedHeight: 35.0,
                backgroundColor: Colors.white,
                flexibleSpace: widget.category != null
                    ? LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          var top = constraints.biggest.height;
                          return FlexibleSpaceBar(
                            titlePadding: EdgeInsets.only(
                              left: top > 71.0
                                  ? 20
                                  : 0, // Or some other logic to position the title
                              bottom: 16,
                            ),
                            title: Text(widget.category ??
                                'UniPlanet'), // Show category if it's not null otherwise 'uniplanet'
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: GlobalVariables.appBarGradient,
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
                leading: widget.category == null
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            Image(
                                image: const AssetImage(
                                    'assets/images/Logo_nbg.png'),
                                width: 30.w,
                                height: 30.h),
                            Text(
                              'UniPlanet',
                              style: GoogleFonts.roboto(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
                leadingWidth: widget.category == null ? 200.w : null,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10.h,
                ),
              ),
              // Other slivers
              if (_showLoadingIndicator)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.h, top: 10.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              widget.category != null
                  ? widget.category == 'Hot Products'
                      ? BlocBuilder<HotProductBloc, HotProductState>(
                          builder: (context, state) {
                          List<Product> productList = state.hotProducts;
                          return ItemBox(productList: productList);
                        })
                      : BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                            List<Product> productList = state.categoryProducts;
                            return ItemBox(productList: productList);
                          },
                        )
                  : BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        // Directly return ItemBox for any state other than LoadingProductState
                        // Assuming that _showLoadingIndicator will handle showing the loader with delay
                        return ItemBox(
                          productList: state.productList,
                        );
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
