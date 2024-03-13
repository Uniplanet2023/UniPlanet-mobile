import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/message.dart';

class MyMessageCard extends StatelessWidget {
  final Message message;
  final String date;

  const MyMessageCard({super.key, required this.message, required this.date});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Ensures the Row only takes needed space
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Date and Icon
          Row(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors
                      .black54, // Changed color for visibility outside Card
                ),
              ),
              const SizedBox(width: 5),
              message.readDate == null
                  ? const SizedBox()
                  : const Icon(
                      Icons.local_fire_department_outlined,
                      size: 20,
                      color: Colors
                          .black54, // Changed color for visibility outside Card
                    ),
            ],
          ),
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
              margin: const EdgeInsets.fromLTRB(5, 5, 15, 5),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 10,
                ),
                child: Text(
                  message.message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
