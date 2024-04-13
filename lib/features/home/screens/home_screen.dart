import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet_mobile/bloc/category/category_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/loader.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/home/widgets/buildProductBox.dart';

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
    if (widget.category == 'Hot Products') {
      context.read<CategoryBloc>().add(const GetHotProductsEvent());
    } else if (widget.category != null) {
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
      context.read<ProductBloc>().add(const LoadMoreProductEvent());
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
      body: NotificationListener<ScrollNotification>(
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
            SliverAppBar(
              pinned: false,
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
                              'UniKet'), // Show category if it's not null otherwise 'UniKet'
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
                          const Image(
                              image: AssetImage('assets/images/Logo_nbg.png'),
                              width: 30,
                              height: 30),
                          Text(
                            'UniKet',
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
              leadingWidth: widget.category == null ? 200 : null,
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
                ? BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is LoadedCategoryState) {
                        final productList = state.categoryProducts;
                        return ItemBox(productList: productList);
                        // return buildProductGrid(
                        //     productList: productList,
                        //     context: context,
                        //     category: widget.category);
                      }
                      return const ItemBox(productList: []);
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
    );
  }
}
