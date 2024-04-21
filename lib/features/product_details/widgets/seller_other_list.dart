import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniket/models/product.dart';

class SellerOtherProductsGrid extends StatelessWidget {
  final List<Product> otherProducts;

  const SellerOtherProductsGrid({
    super.key,
    required this.otherProducts,
  });

  @override
  Widget build(BuildContext context) {
    double totalPadding = 16.w * 2;
    double spaceBetweenItems = 10.w;
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - totalPadding - spaceBetweenItems) / 2;

    // Limit the number of products to 4 or the actual number if less than 4
    int displayCount = otherProducts.length > 4 ? 4 : otherProducts.length;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Wrap(
        spacing: spaceBetweenItems,
        runSpacing: 10.h,
        alignment: WrapAlignment.start,
        children: otherProducts.getRange(0, displayCount).map((product) {
          return Column(
            children: [
              SizedBox(
                width: itemWidth,
                height: 100.h, // To make the image container square
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
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
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
