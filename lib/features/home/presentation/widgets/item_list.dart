import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/product/product_bloc.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/features/home/domain/entities/advertisement.dart';
import 'package:uniplanet/features/home/presentation/widgets/advertisement.dart';
import 'package:uniplanet/features/home/presentation/widgets/item.dart';
import 'package:uniplanet/models/product.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemList extends StatefulWidget {
  final List<Product> productList;
  final List<Advertisement> ads;
  const ItemList({super.key, required this.productList, required this.ads});

  @override
  State<ItemList> createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    var adCount = 0;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // Determine the actual item index (excluding ads)
          final productIndex = index - (index ~/ 6);

          // Insert an ad every 5 items
          if (index % 6 == 5) {
            if (widget.ads.isEmpty) {
              return Container();
            }
            // Loop through ads by using the modulus operator
            int adIndex = adCount % widget.ads.length;
            adCount++;
            return _buildAdContainer(ad: widget.ads[adIndex]);
          }

          // Get the product and build the item
          final product = widget.productList[productIndex];
          return InkWell(
              onTap: () {
                context
                    .read<ProductBloc>()
                    .add(IncreaseClickProductEvent(product.id));
                Navigator.pushNamed(
                  context,
                  AppRoutes.productDetailsPage,
                  arguments: product,
                );
              },
              child: Item(product: product));
        },
        // Total count should include ads as well
        childCount:
            widget.productList.length + (widget.productList.length ~/ 5),
      ),
    );
  }

  Widget _buildAdContainer({required Advertisement ad}) {
    return InkWell(
      onTap: () async {
        if (ad.type == 'Increase Website Visits') {
          if (ad.link != null && ad.link!.isNotEmpty) {
            final Uri url = Uri.parse(ad.link!);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $url';
            }
          }
        }
        if (ad.type == 'Get More messages') {
          if (context.mounted) {
            Navigator.pushNamed(context, AppRoutes.adDetailPage,
                arguments: {'ad': ad});
          }
        }
        // You can add more conditions here for other ad types if needed
      },
      child: AdvertisementItem(ad: ad),
    );
  }
}
