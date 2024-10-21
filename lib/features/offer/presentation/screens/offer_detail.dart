import 'package:flutter/material.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';

import 'package:uniplanet/features/offer/domain/entities/offer.dart';
import 'package:uniplanet/features/offer/presentation/blocs/offer/offer_bloc.dart';
import 'package:uniplanet/features/offer/presentation/widgets/information_section.dart';
import 'package:uniplanet/features/offer/presentation/widgets/qr_code_scanner.dart';
import 'package:uniplanet/features/offer/presentation/widgets/voucher_section.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import CachedNetworkImage

class VoucherPage extends StatefulWidget {
  final Offer offer;

  const VoucherPage({super.key, required this.offer});

  @override
  VoucherPageState createState() => VoucherPageState();
}

class VoucherPageState extends State<VoucherPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey informationKey = GlobalKey();
  bool isVoucherSelected = true;

  // Function to scroll to a specific widget position
  void _scrollToConditions() {
    final context = informationKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Collapsible Image Section with SliverAppBar
          CustomScrollView(
            controller: _scrollController, // Attach the scroll controller here
            slivers: [
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: widget.offer.images.isNotEmpty
                      ? PageView.builder(
                          itemCount:
                              widget.offer.images.length, // Number of images
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: widget.offer.images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child:
                                      CircularProgressIndicator()), // Show a loading indicator
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.error), // Show error icon on failure
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300], // Placeholder if no image
                        ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Theme.of(context).colorScheme.surface),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          // DraggableScrollableSheet for the bottom part
          DraggableScrollableSheet(
            initialChildSize: 0.7, // Start with 70% of screen height
            minChildSize: 0.6, // Minimum height of the sheet
            maxChildSize: 1, // Maximum height of the sheet
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryFixedDim,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Restaurant Name and Category
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.offer.companyName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Western Restaurant', // Optional category or type
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Buttons to switch between Voucher and Information (styled like a TabBar)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isVoucherSelected = true;
                                  });
                                  // Scroll to the top (Voucher section)
                                  _scrollController.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Voucher',
                                      style: TextStyle(
                                        color: isVoucherSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .inverseSurface
                                            : Colors.grey,
                                        fontSize: 16,
                                        fontWeight: isVoucherSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Add a bar indicator under the selected tab
                                    Container(
                                      height: 2,
                                      width: double.infinity,
                                      color: isVoucherSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isVoucherSelected = false;
                                  });
                                  // Scroll to the "Conditions" section
                                  _scrollToConditions();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Information',
                                      style: TextStyle(
                                        color: !isVoucherSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .inverseSurface
                                            : Colors.grey,
                                        fontSize: 16,
                                        fontWeight: !isVoucherSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Add a bar indicator under the selected tab
                                    Container(
                                      height: 2,
                                      width: double.infinity,
                                      color: !isVoucherSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Voucher and claim content
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Voucher(offer: widget.offer),
                            const SizedBox(height: 20),
                            Information(
                              offer: widget.offer,
                              scrollKey: informationKey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating Claim Now Button
          widget.offer.userId == getIt<AccountBloc>().state.account.user.id
              ? Positioned(
                  bottom: 50,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: () {
                      // Remove the offer
                      getIt<GetOfferBloc>().add(
                        RemoveOfferEvent(offerId: widget.offer.offerId),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent[400],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Remove Offer',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )
              : Positioned(
                  bottom: 50,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to QR code scanner page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodeScannerPage(
                            // Navigate to QRCodeScannerPage
                            offer: widget.offer,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[400],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Claim Now',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
