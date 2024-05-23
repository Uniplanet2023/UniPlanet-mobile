import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/sold_product/sold_product_bloc.dart';
import 'package:uniplanet/features/account/widgets/sold_inventory_product_box.dart';
import 'package:uniplanet/models/user_model.dart';

class SoldProductsScreen extends StatefulWidget {
  final User user;
  const SoldProductsScreen({super.key, required this.user});

  @override
  State<SoldProductsScreen> createState() => _SoldProductsScreenState();
}

class _SoldProductsScreenState extends State<SoldProductsScreen> {
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
          .read<SoldProductBloc>()
          .add(LoadMoreSoldProductEvent(userId: widget.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sold Products'),
      ),
      body: BlocBuilder<SoldProductBloc, SoldProductState>(
        builder: (context, state) {
          if (state is LoadingSoldProductState || state is SoldProductInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedMoreSoldProductState && _isLoadingMore ||
              state is EndSoldProductState && _isLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLoadingMore = false;
              });
            });
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SoldInventoryProductBox(
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
