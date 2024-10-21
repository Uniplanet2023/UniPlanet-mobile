import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/presentation/blocs/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/advertiser/presentation/blocs/advertisement/advertisement_bloc.dart';
import 'package:uniplanet/features/advertiser/presentation/widgets/inventory_ads_screen.dart';

class InventoryAdsScreen extends StatefulWidget {
  final User user;
  const InventoryAdsScreen({super.key, required this.user});

  @override
  State<InventoryAdsScreen> createState() => _InventoryAdsScreenState();
}

class _InventoryAdsScreenState extends State<InventoryAdsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
    getIt<MyAdvertisementBloc>().add(GetAdvertisementEvent(id: widget.user.id));
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
      // if (getIt<OnSaleProductBloc>().state is! EndOnSaleProductState) {
      //   setState(() {
      //     _isLoadingMore = true;
      //   });
      //   context
      //       .read<OnSaleProductBloc>()
      //       .add(LoadMoreOnSaleProductEvent(userId: widget.user.id));
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Listings'),
      ),
      body: BlocBuilder<MyAdvertisementBloc, MyAdvertisementState>(
        builder: (context, state) {
          if (state is LoadingAdvertisementState) {
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
              InventoryAdBox(
                title: 'On Sale',
                advertisementList: state.advertisements,
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
