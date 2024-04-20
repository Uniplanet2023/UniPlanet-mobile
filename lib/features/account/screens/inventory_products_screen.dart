import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniket/bloc/on_sale_product/on_sale_product_bloc.dart';
import 'package:uniket/bloc/product/product_bloc.dart';
import 'package:uniket/features/account/widgets/inventory_screen_product_box.dart';
import 'package:uniket/models/user_model.dart';

class InventoryProductsScreen extends StatefulWidget {
  final User user;
  const InventoryProductsScreen({super.key, required this.user});

  @override
  State<InventoryProductsScreen> createState() =>
      _InventoryProductsScreenState();
}

class _InventoryProductsScreenState extends State<InventoryProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    context.read<OnSaleProductBloc>().add(const LoadOnSaleProductEvent());
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      context.read<OnSaleProductBloc>().add(const LoadMoreOnSaleProductEvent());
      // Simulate a delay to load more items
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoadingMore = false;
          // Add more items to your product list here or trigger a Bloc event to load more items
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listings'),
      ),
      body: BlocBuilder<OnSaleProductBloc, OnSaleProductState>(
        builder: (context, state) {
          if (state is LoadingOnSaleProductState ||
              state is OnSaleProductInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              InventoryProductBox(
                productList: state.onSaleProduct,
                controller: _scrollController,
                isLoadingMore: _isLoadingMore,
              ),
            ],
          );
        },
      ),
    );
  }
}
