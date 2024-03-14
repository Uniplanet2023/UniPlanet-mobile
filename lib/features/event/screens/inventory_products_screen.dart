import 'package:flutter/material.dart';

class InventoryProductsScreen extends StatelessWidget {
  const InventoryProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Products'),
      ),
      body: const Center(
        child: Text('Inventory Products screen content goes here.'),
      ),
    );
  }
}
