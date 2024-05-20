import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/common/widgets/loader.dart';
import 'package:uniplanet/features/home/widgets/build_product_box.dart';
import 'package:uniplanet/features/home/widgets/home_header.dart';

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
      if (context.read<ProductBloc>().state is LoadedProductState) {
        context.read<ProductBloc>().add(const LoadMoreProductEvent());
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
              const HomeHeader(),

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
      ),
    );
  }
}
