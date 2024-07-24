import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/presentation/blocs/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/features/account/presentation/widgets/inventory_screen_product_box.dart';
import 'package:uniplanet/core/entities/user.dart';

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
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 10 &&
        !_isLoadingMore) {
      if (getIt<OnSaleProductBloc>().state is! EndOnSaleProductState) {
        setState(() {
          _isLoadingMore = true;
        });
        context
            .read<OnSaleProductBloc>()
            .add(LoadMoreOnSaleProductEvent(userId: widget.user.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Listings'),
      ),
      body: BlocBuilder<OnSaleProductBloc, OnSaleProductState>(
        builder: (context, state) {
          if (state is LoadingOnSaleProductState ||
              state is OnSaleProductInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EndOnSaleProductState && _isLoadingMore ||
              state is LoadedMoreOnSaleProductState && _isLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLoadingMore = false;
              });
            });
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              InventoryProductBox(
                title: 'On Sale',
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
