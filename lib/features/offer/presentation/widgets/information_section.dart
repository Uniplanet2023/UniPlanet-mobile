import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniplanet/features/offer/domain/entities/offer.dart';
import 'package:url_launcher/url_launcher.dart';

class Information extends StatelessWidget {
  final Offer offer;
  final GlobalKey scrollKey;
  const Information({super.key, required this.scrollKey, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: scrollKey,
      children: [
        // const Text(
        //   'Store Location',
        //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        // ),
        // const SizedBox(height: 10),

        // // Store Location Map Placeholder
        // Container(
        //   height: 200,
        //   decoration: BoxDecoration(
        //     color: Colors.grey[300], // Placeholder color for the map
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: const Center(
        //     child: Icon(
        //       Icons.map,
        //       size: 50,
        //       color: Colors.grey,
        //     ),
        //   ),
        // ),

        // const SizedBox(height: 10),
        const Text(
          'Address',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          "${offer.address},${offer.city},${offer.stateAddress},${offer.zipCode}",
          style: const TextStyle(fontSize: 14),
        ),

        // Address and View Map / Copy Address Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                // Copy the address to the clipboard
                Clipboard.setData(ClipboardData(
                    text:
                        "${offer.address},${offer.city},${offer.stateAddress},${offer.zipCode}"));

                // Optional: Show a Snackbar to notify the user that the address was copied
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Address copied to clipboard!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Address'),
            ),
            // TextButton.icon(
            //   onPressed: () {
            //     // Action to view the map
            //   },
            //   icon: const Icon(Icons.map),
            //   label: const Text('View Map'),
            // ),
          ],
        ),

        const SizedBox(height: 20),
        offer.phoneNumber != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        offer.phoneNumber ?? '', // Placeholder phone number
                        style: const TextStyle(fontSize: 14),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Copy the address to the clipboard
                          Clipboard.setData(
                              ClipboardData(text: offer.phoneNumber ?? ''));

                          // Optional: Show a Snackbar to notify the user that the address was copied
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Address copied to clipboard!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : const SizedBox(),
        // Phone Number

        // Link Section
        offer.link != null && offer.link != ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Link',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (offer.link != null && offer.link!.isNotEmpty) {
                        final Uri url = Uri.parse(
                          offer.link!.startsWith('http')
                              ? offer.link!
                              : 'https://${offer.link}',
                        );
                        launchUrl(url);
                      } else {
                        // Handle case where link is null or empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid link')),
                        );
                      }
                    },
                    icon: const Icon(Icons.link),
                    label: const Text('Visit Website'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
