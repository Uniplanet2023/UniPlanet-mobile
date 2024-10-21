import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/offer/domain/entities/offer.dart';
import 'package:uniplanet/features/offer/presentation/blocs/qr_code_scan/qr_code_scan_bloc.dart';
import 'package:uniplanet/features/offer/presentation/screens/offer_redeem.dart';

class QRCodeScannerPage extends StatefulWidget {
  final Offer offer;

  const QRCodeScannerPage({super.key, required this.offer});

  @override
  QRCodeScannerPageState createState() => QRCodeScannerPageState();
}

class QRCodeScannerPageState extends State<QRCodeScannerPage>
    with WidgetsBindingObserver {
  Barcode? _barcode;
  bool _hasScanned = false; // A flag to track if a scan has been processed

  MobileScannerController controller = MobileScannerController(
    autoStart: true,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Start the camera scanner.
    unawaited(controller.start());
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    // If a barcode has already been scanned, don't do anything.
    if (_hasScanned) return;

    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });

      if (barcodes.barcodes.firstOrNull != null &&
          barcodes.barcodes[0].rawValue != null) {
        final String code = barcodes.barcodes[0].rawValue!;
        _onBarcodeDetected(code);

        // Set the flag to true to prevent further scans.
        _hasScanned = true;

        // Stop the scanner after detecting the first barcode
        controller.stop();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (await Permission.camera.isDenied ||
        await Permission.camera.isPermanentlyDenied) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed, but only if no barcode has been scanned.
        if (!_hasScanned) {
          unawaited(controller.start());
        }
        break;
      case AppLifecycleState.inactive:
        unawaited(controller.stop());
        break;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onBarcodeDetected(String code) {
    getIt<QrCodeScanBloc>()
        .add(QrCodeScanned(token: code, offerId: widget.offer.offerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('UniPlanet', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _handleBarcode,
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Please scan the QR code at the restaurant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          BlocBuilder<QrCodeScanBloc, QrCodeScanState>(
            builder: (context, state) {
              if (state is QrCodeScanLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is QrCodeScanSuccess) {
                Future.microtask(
                    () => _navigateToSuccessPage(context, widget.offer));
              } else if (state is QrCodeScanFailure) {
                Future.microtask(() => _showErrorDialog(context, state.error));
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  void _navigateToSuccessPage(BuildContext context, Offer offer) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OfferRedeemPage(offer: offer),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scan Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller
                  .start(); // Restart the camera after dismissing the error dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
