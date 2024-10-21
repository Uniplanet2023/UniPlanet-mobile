import 'package:flutter/material.dart';

Widget buildInsightCard({
  required String title,
  required String subtitle,
  required String value,
}) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    padding: const EdgeInsets.all(16.0),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    ),
  );
}
