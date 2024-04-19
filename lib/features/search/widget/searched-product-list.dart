import 'package:flutter/material.dart';
import 'package:uniket/bloc/index.dart';
import 'package:uniket/features/search/widget/searched-product.dart';
import 'package:uniket/models/product.dart';

class SearchedProductList extends StatefulWidget {
  final List<Product> products;
  final String query;
  const SearchedProductList({
    super.key,
    required this.products,
    required this.query,
  });

  @override
  State<SearchedProductList> createState() => _SearchedProductListState();
}

class _SearchedProductListState extends State<SearchedProductList> {
  final ScrollController _scrollController = ScrollController();
  bool isEnded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!isEnded &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      // Trigger your bloc event here to load more products
      context
          .read<SearchProductBloc>()
          .add(LoadMoreSearchProductEvent(productName: widget.query));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchProductBloc, SearchProductState>(
      builder: (context, state) {
        if (state is EndSearchingProductState) {
          isEnded = true;
        }
        return state.productList.isEmpty
            ? const Center(
                child: Text('No products found'),
              )
            : RefreshIndicator(
                onRefresh: () {
                  context
                      .read<SearchProductBloc>()
                      .add(LoadSearchProductEvent(productName: widget.query));
                  return Future.value();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.products.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= widget.products.length &&
                        widget.products.length > 9 &&
                        state is! EndSearchingProductState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (index == widget.products.length) {
                      return const SizedBox(height: 100);
                    }
                    return SearchedProduct(
                      product: widget.products[index],
                    );
                  },
                ),
              );
      },
    );
  }
}
