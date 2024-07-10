import 'package:flutter/material.dart';
import 'package:uniplanet/features/report/presentation/screen/report_detail_screen.dart';
import 'package:uniplanet/features/report/presentation/widget/show_dialog.dart';
import 'package:uniplanet/models/user.dart';

class SomethingElse extends StatelessWidget {
  final User client;
  final String productId;

  const SomethingElse(
      {super.key, required this.client, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Please select a reason for reporting this user.'),
      ),
      body: ListView(
        children: [
          buildListItem(context, 'Illegal activity', client, productId),
          buildListItem(
              context, 'Inappropriate profile photo', client, productId),
          buildListItem(context, 'Offensive nickname', client, productId),
          buildListItem(context, 'Other', client, productId),
        ],
      ),
    );
  }

  Widget buildListItem(
      BuildContext context, String reportType, User client, String productId) {
    bool showTrailingIcon = reportType == 'Other';

    return ListTile(
      title: Text(reportType),
      trailing: showTrailingIcon ? const Icon(Icons.arrow_forward_ios) : null,
      onTap: () {
        if (reportType == 'Illegal activity' ||
            reportType == 'Inappropriate profile photo' ||
            reportType == 'Offensive nickname') {
          showReportDialog(
              context: context,
              reportType: reportType,
              client: client,
              productId: productId);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportDetailPage(
                  reportType: reportType, client: client, productId: productId),
            ),
          );
        }
      },
    );
  }
}
