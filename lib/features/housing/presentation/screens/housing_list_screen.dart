import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/housing/presentation/housing/housing_bloc.dart';
import 'package:uniplanet/features/housing/presentation/widgets/housing_card.dart';

class HousingList extends StatefulWidget {
  const HousingList({super.key});

  @override
  State<HousingList> createState() => _HousingListState();
}

class _HousingListState extends State<HousingList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
    getIt<GetHousingBloc>().add(GetMyHousingPosts());
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
      if (getIt<GetHousingBloc>().state is! HousingPostsEnd) {
        setState(() {
          _isLoadingMore = true;
        });
        context.read<GetHousingBloc>().add(FetchMoreHousingPosts());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Housing List'),
      ),
      body: BlocBuilder<GetHousingBloc, GetHousingState>(
        builder: (context, state) {
          if (state is HousingPostsLoading || state is HousingInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HousingPostsLoaded || state is HousingPostsEnd) {
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   setState(() {
            //     _isLoadingMore = false;
            //   });
            // });
            return ListView.builder(
              itemCount: state.housingPosts.length,
              itemBuilder: (context, index) {
                return HousingPostCard(housing: state.housingPosts[index]);
              },
            );
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: const <Widget>[
              // InventoryProductBox(
              //   title: 'On Sale',
              //   productList: state.onSaleProduct,
              //   controller: _scrollController,
              //   isLoadingMore: _isLoadingMore,
              // ),
            ],
          );
        },
      ),
    );
  }
}
