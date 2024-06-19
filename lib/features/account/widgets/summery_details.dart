import 'package:flutter/material.dart';
import 'package:uniplanet/features/account/widgets/custom_card_widget.dart';
import 'package:uniplanet/models/advertiser.dart';

class SummaryDetails extends StatelessWidget {
  final Advertiser advertiser;
  const SummaryDetails({super.key, required this.advertiser});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Colors.white.withOpacity(0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDetails('Credit Used', advertiser.usedCredit.toStringAsFixed(2)),
          // buildDetails('Cost Per Click', '${advertiser.costPerClick}\$'),
          buildDetails('My Credit',
              "${(advertiser.givenCredit - advertiser.usedCredit).toStringAsFixed(2)}\$"),
          buildDetails('Cost', "${advertiser.spent}\$"),
          buildDetails('My Buget', "${advertiser.budget}\$"),
        ],
      ),
    );
  }

  Widget buildDetails(String key, String value) {
    return Column(
      children: [
        Text(
          key,
          style: const TextStyle(fontSize: 11, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}
