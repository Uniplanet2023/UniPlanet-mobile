import 'package:flutter/material.dart';
import 'package:uniplanet/features/report/screen/report_detail_screen.dart';
import 'package:uniplanet/features/report/screen/report_other_screen.dart';
import 'package:uniplanet/features/report/widget/show_dialog.dart';
import 'package:uniplanet/models/user.dart';

Widget buildListItem(
    BuildContext context, String reportType, User client, String productId) {
  bool showTrailingIcon = !(reportType == 'No response' ||
      reportType == 'Professional seller' ||
      reportType == 'No show after agreeing on a time and place');

  return ListTile(
    title: Text(reportType),
    trailing: showTrailingIcon ? const Icon(Icons.arrow_forward_ios) : null,
    onTap: () {
      if (reportType == 'No response' ||
          reportType == 'No show after agreeing on a time and place' ||
          reportType == 'Professional seller') {
        showReportDialog(
            context: context,
            reportType: reportType,
            client: client,
            productId: productId);
      } else if (reportType == 'Something else') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SomethingElse(client: client, productId: productId),
          ),
        );
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
