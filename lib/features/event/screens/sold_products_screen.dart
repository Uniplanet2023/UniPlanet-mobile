import 'package:flutter/material.dart';

class SoldProductsScreen extends StatelessWidget {
  const SoldProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sold Products Products'),
      ),
      body: const Center(
        child: Text('Sold Product screen content goes here.'),
      ),
    );
  }
}
