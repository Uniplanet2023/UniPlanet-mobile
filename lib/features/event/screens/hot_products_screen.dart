import 'package:flutter/material.dart';

class HotProductsScreen extends StatelessWidget {
  const HotProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Products'),
      ),
      body: const Center(
        child: Text('Hot products screen content goes here.'),
      ),
    );
  }
}
