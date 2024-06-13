import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/report/report_bloc.dart';
import 'package:uniplanet/models/user.dart';

void showReportDialog(
    {required BuildContext context,
    required String reportType,
    required User client,
    required String productId}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(reportType),
        content: const Text(
            'Are you sure you want to report this user for no response?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Report'),
            onPressed: () {
              context.read<ReportBloc>().add(ReportUserEvent(
                  description: reportType,
                  reportedUserId: client.id,
                  productId: productId,
                  reportType: reportType));
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
