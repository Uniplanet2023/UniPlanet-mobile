import 'package:flutter/material.dart';

Future<void> removeProductDialog(
  BuildContext context,
  String title,
  String description,
  IconData icon,
  Function onConfirmed,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button!
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Icon(icon, size: 40, color: Colors.red),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss the dialog
            },
          ),
          TextButton(
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss the dialog
              onConfirmed(); // Call the function passed in
            },
          ),
        ],
      );
    },
  );
}
