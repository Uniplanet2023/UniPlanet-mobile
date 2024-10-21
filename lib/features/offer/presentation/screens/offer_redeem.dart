import 'package:flutter/material.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/offer/domain/entities/offer.dart';
import 'package:uniplanet/features/offer/presentation/blocs/qr_code_scan/qr_code_scan_bloc.dart';

class OfferRedeemPage extends StatefulWidget {
  final Offer offer;

  const OfferRedeemPage({super.key, required this.offer});

  @override
  State<OfferRedeemPage> createState() => _OfferRedeemPageState();
}

class _OfferRedeemPageState extends State<OfferRedeemPage> {
  @override
  void initState() {
    super.initState();
    getIt<QrCodeScanBloc>().add(QrCodeScanInit());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Redeemed'),
        automaticallyImplyLeading: false, // Disable back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.redeem,
              color: Colors.greenAccent[400],
              size: 120,
            ),
            const SizedBox(height: 20),
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent[400],
              ),
            ),
            const Text(
              'Please show this screen to the staff to redeem your offer.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            const Text(
              'You have successfully redeemed the following offer:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Displaying Offer details
            Text(
              widget.offer.companyName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.offer.voucher,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Address: ${widget.offer.address}, ${widget.offer.city}, ${widget.offer.stateAddress}, ${widget.offer.zipCode}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[400],
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 120),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Go Back',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
