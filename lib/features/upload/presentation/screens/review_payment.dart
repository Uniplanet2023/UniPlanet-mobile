import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uniplanet/core/network/repository/index.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/launch_url.dart';
import 'package:uniplanet/features/upload/domain/entities/payment_intent.dart';
import 'package:uniplanet/features/upload/presentation/blocs/payment/payment_bloc.dart';

class ReviewPaymentScreen extends StatefulWidget {
  final double totalPayment;
  final Function({required double totalPayment}) uploadAd;

  const ReviewPaymentScreen({
    super.key,
    required this.totalPayment,
    required this.uploadAd,
  });

  @override
  ReviewPaymentScreenState createState() => ReviewPaymentScreenState();
}

class ReviewPaymentScreenState extends State<ReviewPaymentScreen> {
  bool _isExpanded = true; // Track whether "See more" has been clicked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review payment'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) async {
          if (state is PaymentSuccess) {
            var token = await DioHelper.instance.getSessionToken();
            launchUrlWithCookie(
              'https://uniplanet.shop/ad-payment?clientSecret=${state.paymentIntent.clientSecret}&token=${state.paymentIntent.token}',
              'session=$token',
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Step 3 of 3',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    'Ad summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${widget.totalPayment} / month',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isExpanded
                                ? 'Charge is for 31 days upfront. Your ad will run continuously and auto-renew every 31 days...'
                                : 'Charge is for 31 days upfront. Your ad will run continuously and auto-renew every 31 days...',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          if (!_isExpanded)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isExpanded = true;
                                });
                              },
                              child: const Text(
                                'See more',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          if (_isExpanded)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isExpanded = false;
                                });
                              },
                              child: const Text(
                                'See less',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            widget.uploadAd(totalPayment: widget.totalPayment);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Navigate Payment Page',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Successful'),
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.bottomBarPage,
          (route) => false,
        );
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Failed'),
          ),
        );
      });
    } on StripeException catch (e) {
      // Handle error
    }
  }

  Future<void> _showPaymentSheet(PaymentIntentEntity paymentIntent) async {
    try {
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent.clientSecret,
          style: ThemeMode.light,
          merchantDisplayName: 'UniPlanet',
        ),
      )
          .then((value) {
        displayPaymentSheet(context);
      });
    } catch (e) {
      // Handle payment failure
    }
  }
}
