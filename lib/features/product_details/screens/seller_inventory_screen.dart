import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/seller_sale_product/seller_sale_product_bloc.dart';
import 'package:uniplanet/features/account/widgets/inventory_screen_product_box.dart';
import 'package:uniplanet/models/user_model.dart';

class SellerProductsScreen extends StatefulWidget {
  final User user;
  const SellerProductsScreen({super.key, required this.user});

  @override
  State<SellerProductsScreen> createState() => _SellerProductsScreenState();
}

class _SellerProductsScreenState extends State<SellerProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
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
      context
          .read<SellerSaleProductBloc>()
          .add(LoadMoreSellerSaleProductEvent(userId: widget.user.id));
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
      body: BlocBuilder<SellerSaleProductBloc, SellerSaleProductState>(
        builder: (context, state) {
          if (state is LoadingSellerSaleProductState ||
              state is SellerSaleProductInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              InventoryProductBox(
                title: 'Seller Sale',
                productList: state.sellerProduct,
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
