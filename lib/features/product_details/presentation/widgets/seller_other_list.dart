import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/features/product_details/presentation/pages/product_details_screen.dart';
import 'package:uniplanet/models/product.dart';

class SellerOtherProductsGrid extends StatelessWidget {
  final List<Product> otherProducts;

  const SellerOtherProductsGrid({
    super.key,
    required this.otherProducts,
  });

  @override
  Widget build(BuildContext context) {
    // Limit the number of products to 4 or the actual number if less than 4
    int displayCount = otherProducts.length > 4 ? 4 : otherProducts.length;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: otherProducts.getRange(0, displayCount).map((product) {
          return GestureDetector(
            onTap: () {
              // Navigate to the product details screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: product,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  height: 100, // To make the image container square
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product.images.isEmpty
                        ? const SizedBox()
                        : CachedNetworkImage(
                            imageUrl: product.images.first,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 150,
                  child: Text(
                    product.name,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    '\$${product.price}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
