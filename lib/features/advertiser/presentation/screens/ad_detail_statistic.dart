import 'package:flutter/material.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';
import 'package:uniplanet/features/advertiser/presentation/screens/mail_form_screen.dart';
import 'package:uniplanet/features/advertiser/presentation/widgets/insight_tile.dart';
import 'package:uniplanet/features/advertiser/presentation/widgets/navigation_tile.dart';
import 'package:uniplanet/features/advertiser/presentation/widgets/unsubscribe_button.dart';

class InsightsPage extends StatelessWidget {
  final Advertisement ad;
  const InsightsPage({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Insight card for "Last 30 days - Page visits"
                  buildInsightCard(
                    title: 'Last 30 days',
                    subtitle: 'Impressions',
                    value: ad.impressions.toString(),
                  ),
                  // First row with Faves and Recommendations
                  Row(
                    children: [
                      // Faves
                      Expanded(
                        child: buildInsightCard(
                          title: 'All-time',
                          subtitle: 'Impressions',
                          value: ad.impressions.toString(),
                        ),
                      ),

                      // Recommendations
                      Expanded(
                        child: buildInsightCard(
                          title: 'All-time',
                          subtitle: 'Clicks',
                          value: ad.clicks.toString(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Get Recommendations Banner
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'If you encounter any issues or have concerns, please email us at uniplanet.info@gmail.com, or click the button below to send a message directly to our support team.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Handle "Get Support" button press
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MailFormPage(
                                  advertisement: ad,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text(
                            'Get Support',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bottom Navigation ListTiles
                  const Column(
                    children: [
                      BuildNavigationTile(title: 'Page visits'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Unsubscribe Button at the Bottom
          UnSubscribeButton(
            advertisement: ad,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
