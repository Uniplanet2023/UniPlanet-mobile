import 'package:flutter/material.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/features/account/widgets/inventory_screen_product_box.dart';

class LikedProductsScreen extends StatefulWidget {
  const LikedProductsScreen({super.key});

  @override
  State<LikedProductsScreen> createState() => _LikedProductsScreenState();
}

class _LikedProductsScreenState extends State<LikedProductsScreen> {
  final ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;

  void loadMoreItems() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 60 &&
        !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      context.read<LikeBloc>().add(const LoadMoreLikeEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(loadMoreItems);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Liked Products'),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          BlocBuilder<LikeBloc, LikeState>(
            builder: (context, state) {
              if (state is LikeLoadedMore && isLoadingMore ||
                  state is LikeEnd && isLoadingMore) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    isLoadingMore = false;
                  });
                });
              }
              return InventoryProductBox(
                title: 'Liked',
                productList: state.likeProduct,
                controller: scrollController,
                isLoadingMore: isLoadingMore,
              );
            },
          ),
        ],
      ),
    );
  }
}
