import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/features/housing/domain/entities/housing_post.dart';
import 'package:uniplanet/features/housing/presentation/screens/housing_detail_page.dart';

class HousingPostCard extends StatelessWidget {
  final HousingPost housing;

  const HousingPostCard({super.key, required this.housing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HousingDetailPage(
            housing: housing,
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          elevation: 5,
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10.0)),
                child: CachedNetworkImage(
                  imageUrl: housing.images[0],
                  height: 150.0, // Adjusted height
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${housing.monthlyPayment.toString()}/mo',
                          style: const TextStyle(
                            fontSize: 20, // Adjusted font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        housing.isUtilityIncluded
                            ? Text(
                                ' + Utils included',
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${housing.title} / ${housing.category}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            housing.location,
                            style: const TextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
