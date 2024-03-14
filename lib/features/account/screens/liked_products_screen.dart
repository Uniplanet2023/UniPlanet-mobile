import 'package:flutter/material.dart';

class LikedProductsScreen extends StatelessWidget {
  const LikedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Products'),
      ),
      body: const Center(
        child: Text('Liked Products screen content goes here.'),
      ),
    );
  }
}
