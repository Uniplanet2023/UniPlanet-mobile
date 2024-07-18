import 'package:flutter/material.dart';
import 'package:uniplanet/features/auth/domain/entities/user.dart';
import 'package:uniplanet/features/report/presentation/widget/build_list.dart';

class ReportUserPage extends StatelessWidget {
  final User client;
  final String productId;
  const ReportUserPage(
      {super.key, required this.client, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
          title: Text(
        'Select a reason for reporting',
        maxLines: 2,
        style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary, fontSize: 18),
      )),
      body: ListView(
        children: [
          buildListItem(context, 'Professional seller', client, productId),
          buildListItem(context, 'No show after agreeing on a time and place',
              client, productId),
          buildListItem(context, 'No response', client, productId),
          buildListItem(
              context, 'Abusive or offensive language', client, productId),
          buildListItem(context, 'Sexual harassment', client, productId),
          buildListItem(
              context, 'Transaction and refund disputes', client, productId),
          buildListItem(context, 'Scam/fraudulent activity', client, productId),
          buildListItem(context, 'Something else', client, productId),
        ],
      ),
    );
  }
}
