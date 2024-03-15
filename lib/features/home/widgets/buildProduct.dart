import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/features/product_details/screens/product_details_screen.dart';
import 'package:uniplanet_mobile/models/product.dart';

Widget buildProductItem(
    {required BuildContext context, required Product product}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        AppRoutes.productDetailsPage,
        arguments: product,
      );
    },
    child: Column(
      children: [
        SizedBox(
          height: 130.h,
          width: 150.w,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: CachedNetworkImage(
                imageUrl: product.images[0],
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red, size: 80),
              ),
            ),
          ),
        ),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
