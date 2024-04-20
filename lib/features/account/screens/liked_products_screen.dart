import 'package:flutter/material.dart';
import 'package:uniket/bloc/index.dart';
import 'package:uniket/features/account/widgets/inventory_screen_product_box.dart';

class LikedProductsScreen extends StatefulWidget {
  const LikedProductsScreen({super.key});

  @override
  State<LikedProductsScreen> createState() => _LikedProductsScreenState();
}

class _LikedProductsScreenState extends State<LikedProductsScreen> {
  final ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;

  void loadMoreItems() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      // Simulate a delay to load more items
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoadingMore = false;
          // Add more items to your product list here or trigger a Bloc event to load more items
        });
      });
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
      appBar: AppBar(
        title: const Text('Liked Products'),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          BlocBuilder<LikeBloc, LikeState>(
            builder: (context, state) {
              return InventoryProductBox(
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
