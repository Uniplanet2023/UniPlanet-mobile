import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/network/repository/index.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/launch_url.dart';
import 'package:uniplanet/features/upload/domain/entities/payment_intent.dart';
import 'package:uniplanet/features/upload/presentation/blocs/payment/payment_bloc.dart';

class ReviewPaymentScreen extends StatefulWidget {
  final String tier;
  final double totalPayment;
  final Function({required String tier}) uploadAd;

  const ReviewPaymentScreen({
    super.key,
    required this.totalPayment,
    required this.tier,
    required this.uploadAd,
  });

  @override
  ReviewPaymentScreenState createState() => ReviewPaymentScreenState();
}

class ReviewPaymentScreenState extends State<ReviewPaymentScreen> {
  bool _isExpanded = false; // Track whether "See more" has been clicked

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
            var token = DioHelper.instance.session;
            launchUrlWithCookie(
              '$websiteURI/ad-payment?clientSecret=${state.paymentIntent.clientSecret}&token=${state.paymentIntent.token}',
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
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isExpanded
                                ? 'Charge is for 31 days upfront. Your ad will run continuously and auto-renew every 31 days. By clicking “Publish” below, you agree that you have read, understand, and agree to be bound by the UniPlanet Ads Terms of Service. You acknowledge and agree that if you purchase a campaign on a continuous basis or any campaign of a fixed duration of longer than 31 days, UniPlanet will automatically charge the campaign budget amount you have set above to your payment method in advance 31 days following the date of the most recent charge to your account on a recurring basis until your campaign expires or is cancelled by you. You further authorize UniPlanet to charge your payment method the campaign budget amount on an earlier date if you have spent the campaign budget amount prior to your recurring payment date (including through the purchase of multiple campaigns) or on a later date if you haven’t spent the campaign budget amount prior to your recurring payment date. If you purchase subsequent campaigns, you acknowledge and agree that UniPlanet will utilize your account balance for subsequent campaigns and automatically charge your payment method for all campaigns in accordance with the payment schedule for this campaign. For any continuous ad or set duration ad scheduled to run beyond its current 31-day billing cycle, you may cancel to avoid future charges by going to the ‘Ads’ tab in your account, clicking the “Manage ads” button, selecting the ad you want to cancel, and then selecting “Cancel ad.” You can visit our Help Center if you need to contact us with any questions or concerns.'
                                : 'Charge is for 31 days upfront. Your ad will run continuously and auto-renew every 31 days. By clicking “Publish” below, you agree that…',
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
      bottomNavigationBar: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  widget.uploadAd(tier: widget.tier);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
            );
          }
        },
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
    } on StripeException {
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
