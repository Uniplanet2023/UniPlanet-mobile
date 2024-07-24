import 'package:flutter/material.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/report/presentation/bloc/report_bloc.dart';

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
              getIt<ReportBloc>().add(ReportUserEvent(
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
