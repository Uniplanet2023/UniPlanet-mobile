import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
  }) : super(key: key);
  final String message;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Card containing the message
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45,
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: GlobalVariables.primaryColor,
              margin: const EdgeInsets.fromLTRB(15, 5, 5, 5),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          // Date and Icon
          Row(
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600], // Style to match SenderMessageCard
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.done_all,
                size: 20,
                color: Colors.grey[600], // Color to match the text style
              ),
            ],
          ),
        ],
      ),
    );
  }
}
