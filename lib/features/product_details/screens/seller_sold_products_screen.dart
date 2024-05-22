import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/seller_sold_product/sold_product_bloc.dart';
import 'package:uniplanet/features/account/widgets/inventory_screen_product_box.dart';
import 'package:uniplanet/models/user_model.dart';

class SellerSoldProductsScreen extends StatefulWidget {
  final User user;
  const SellerSoldProductsScreen({super.key, required this.user});

  @override
  State<SellerSoldProductsScreen> createState() =>
      _SellerSoldProductsScreenState();
}

class _SellerSoldProductsScreenState extends State<SellerSoldProductsScreen> {
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
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      context
          .read<SellerSoldProductBloc>()
          .add(LoadMoreSellerSoldProductEvent(userId: widget.user.id));
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
        title: const Text('Sold Products'),
      ),
      body: BlocBuilder<SellerSoldProductBloc, SellerSoldProductState>(
        builder: (context, state) {
          if (state is LoadingSellerSoldProductState ||
              state is SellerSoldProductInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              InventoryProductBox(
                title: 'Seller Sold',
                productList: state.soldProduct,
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
