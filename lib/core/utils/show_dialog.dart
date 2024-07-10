import 'package:flutter/material.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';

Future<bool> showOptionDialog(
    BuildContext context, String title, String message) async {
  return await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: Icon(
                      Icons.notifications_active,
                      size: 50,
                      color: GlobalVariables.secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'Deny',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.red),
                )),
            TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(
                  'Allow',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: GlobalVariables.secondaryColor),
                )),
          ],
        );
      });
}
