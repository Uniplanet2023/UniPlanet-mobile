import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';

class AdvertisementItem extends StatelessWidget {
  const AdvertisementItem({
    super.key,
    required this.ad,
  });

  final Advertisement ad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: "product-picture-${ad.id}-${UniqueKey().hashCode}",
                    child: ad.images.isEmpty
                        ? const Icon(
                            Icons.image_not_supported,
                            size: 100,
                          )
                        : CachedNetworkImage(
                            cacheManager: GlobalVariables.customCacheManager,
                            imageUrl: ad.images[0],
                            key: UniqueKey(),
                            fit: BoxFit.cover,
                            height: 110,
                            width: 110,
                            errorWidget: (context, url, error) => Container(
                              color: Colors.black12,
                              child: const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${ad.adName[0].toUpperCase()}${ad.adName.substring(1)}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          ad.type,
                          style: const TextStyle(
                            color: GlobalVariables.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              ad.status == 'active'
                                  ? FontAwesomeIcons.check
                                  : Icons.pending_actions_outlined,
                              size: 16,
                              color: ad.status == 'active'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            Expanded(
                              child: Text(
                                ad.status,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: ad.status == 'active'
                                      ? Colors.green
                                      : ad.status == 'pending'
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Plan: ${ad.tier}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 0.2,
              indent: 8,
              endIndent: 8,
            ),
          ],
        ),
      ),
    );
  }
}
