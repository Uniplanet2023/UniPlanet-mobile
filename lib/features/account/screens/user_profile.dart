import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;
  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 245, 234, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 245, 234, 1),
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GlassContainer.clearGlass(
              padding: const EdgeInsets.all(8),
              borderColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              shadowColor: Colors.white,
              blur: 10,
              elevation: 8,
              height: 360,
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(user.email),
                  Text(
                    user.school,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Listings',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '0',
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Column(
                        children: [
                          Text(
                            'Sold',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '0',
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GlassContainer.clearGlass(
              padding: const EdgeInsets.all(8),
              borderColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              shadowColor: Colors.white,
              blur: 10,
              elevation: 8,
              height: 100,
              width: 400,
              child: const Text(
                'Inventory',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GlassContainer.clearGlass(
              padding: const EdgeInsets.all(8),
              borderColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              shadowColor: Colors.white,
              blur: 10,
              elevation: 8,
              height: 100,
              width: 400,
              child: const Text('Sold'),
            ),
          ],
        ),
      ),
    );
  }
}
