import 'package:flutter/material.dart';

class BuildNavigationTile extends StatelessWidget {
  final String title;

  const BuildNavigationTile({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Handle navigation tap
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preparing'),
          ),
        );
      },
    );
  }
}
