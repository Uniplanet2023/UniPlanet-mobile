import 'package:flutter/material.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/presentation/widgets/pie_chart_widget.dart';
import 'package:uniplanet/features/account/presentation/widgets/summary_details.dart';

class SummaryWidget extends StatelessWidget {
  final AdvertiserEntity advertiser;
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
