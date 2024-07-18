import 'package:flutter/material.dart';
import 'package:uniplanet/features/account/presentation/widgets/pie_chart_widget.dart';
import 'package:uniplanet/features/account/presentation/widgets/summery_details.dart';
import 'package:uniplanet/models/advertiser.dart';

class SummaryWidget extends StatelessWidget {
  final Advertiser advertiser;
  const SummaryWidget({super.key, required this.advertiser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Chart(advertiser: advertiser),
          const SizedBox(height: 16),
          SummaryDetails(advertiser: advertiser),

          // Scheduled(),
        ],
      ),
    );
  }
}
