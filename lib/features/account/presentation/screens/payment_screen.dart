import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniPlanet Premium'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscribe to UniPlanet Premium',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unlock Exclusive Benefits!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Join UniPlanet Premium to enjoy a seamless and enhanced experience with the following exclusive benefits:',
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.check),
              title: Text('Watch Free Items'),
              subtitle: Text(
                  'Gain access to exclusive content and items available for free to our premium subscribers.'),
            ),
            const ListTile(
              leading: Icon(Icons.check),
              title: Text('Skip Ads'),
              subtitle: Text(
                  'Enjoy an ad-free experience while browsing and interacting on UniPlanet.'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Subscription Plan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Monthly Subscription'),
              subtitle: const Text('\$9.99 per month'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Handle monthly subscription logic here
                },
                child: const Text('Subscribe'),
              ),
            ),
            ListTile(
              title: const Text('Annual Subscription'),
              subtitle: const Text('\$99.99 per year (Save 16%)'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Handle annual subscription logic here
                },
                child: const Text('Subscribe'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Q: Can I cancel my subscription anytime?'),
            const Text(
                'A: Yes, you can cancel your subscription at any time through your account settings. You will continue to have access to premium benefits until the end of your billing period.'),
            const SizedBox(height: 8),
            const Text('Q: Will my subscription automatically renew?'),
            const Text(
                'A: Yes, your subscription will automatically renew at the end of each billing period. You can turn off auto-renewal in your account settings.'),
            const SizedBox(height: 8),
            const Text('Q: Do you offer refunds?'),
            const Text(
                'A: We do not offer refunds for partial billing periods. You will continue to have access to premium benefits until the end of your billing period.'),
            const SizedBox(height: 8),
            const Text('Q: How do I update my payment information?'),
            const Text(
                'A: You can update your payment information in your account settings under the subscription section.'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SubscriptionPage(),
  ));
}
