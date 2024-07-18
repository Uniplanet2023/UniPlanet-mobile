import 'package:flutter/material.dart';
import 'package:uniplanet/models/message.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
  });
  final Message message;
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
              color: Theme.of(context).colorScheme.primaryFixedDim,
              margin: const EdgeInsets.fromLTRB(15, 5, 5, 5),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
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
          // Date and Icon
          Row(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54, // Style to match SenderMessageCard
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
        ],
      ),
    );
  }
}
