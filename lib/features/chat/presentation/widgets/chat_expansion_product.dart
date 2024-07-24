import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/features/chat/presentation/get_product/get_product_bloc.dart';
import 'package:uniplanet/features/product_details/presentation/pages/product_details_screen.dart';

ExpansionPanelList chatExpansionPanel(GetProductLoaded state,
    BuildContext context, bool isExpanded, Function isExpandedCallback) {
  return ExpansionPanelList(
    expansionCallback: (int index, bool isExpanded) {
      isExpandedCallback(!isExpanded);
    },
    children: [
      ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(state.product!.name),
          );
        },
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: state.product!)));
              },
              child: CachedNetworkImage(
                imageUrl: state.product!.images[0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150, // Adjust the size as needed
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                '\$${state.product!.price}',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Product Detail'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(
                    color: Theme.of(context).colorScheme.tertiaryContainer),
              ),
              onPressed: () {
                // Review Product
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: state.product!)));
              },
            ),
          ],
        ),
        isExpanded: isExpanded,
      ),
    ],
  );
}
