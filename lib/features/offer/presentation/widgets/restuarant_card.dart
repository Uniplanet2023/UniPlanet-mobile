import 'package:flutter/material.dart';
import 'package:uniplanet/features/offer/domain/entities/offer.dart';
import 'package:uniplanet/features/offer/presentation/screens/offer_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RestaurantCard extends StatelessWidget {
  final Offer offer;

  const RestaurantCard({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to VoucherPage and pass the offer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VoucherPage(offer: offer), // Passing the offer
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        color: Theme.of(context).colorScheme.secondaryFixedDim,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16), // Rounded corners for the card
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the company image (first image from the list) with rounded corners
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ), // Rounded corners for the top image
              child: offer.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: offer
                          .images[0], // Display the first image in the list
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color:
                            Colors.grey[300], // Placeholder color while loading
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: Colors.grey[
                            300], // Display placeholder if image fails to load
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[300], // Placeholder if no image
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displaying the company name
                  Text(
                    offer.companyName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  // Displaying the voucher (discount info)
                  SelectableText(
                      "${offer.address},${offer.city}, ${offer.stateAddress}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface)),
                  const SizedBox(height: 4),
                  Text(offer.voucher,
                      style: const TextStyle(color: Colors.green)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
