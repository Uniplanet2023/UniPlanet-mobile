import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet/features/product_details/screens/product_details_screen.dart';
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
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
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
                  width: 150.w,
                  height: 100.h, // To make the image container square
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: product.images.isEmpty
                        ? const SizedBox()
                        : CachedNetworkImage(
                            imageUrl: product.images.first,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  product.name,
                  style: TextStyle(fontSize: 14.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${product.price}',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
