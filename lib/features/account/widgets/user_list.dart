import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfile {
  final String imageUrl;
  final String username;

  UserProfile({required this.imageUrl, required this.username});
}

class UserList extends StatelessWidget {
  UserList({
    super.key,
  });

  final List<UserProfile> users = [
    UserProfile(
        imageUrl: 'https://via.placeholder.com/150', username: 'User 1'),
    UserProfile(
        imageUrl: 'https://via.placeholder.com/150', username: 'User 2'),
    UserProfile(
        imageUrl: 'https://via.placeholder.com/150', username: 'User 3'),
    // Add more user profiles here
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users.map((user) => GlassListItem(user: user)).toList(),
    );
  }
}

class GlassListItem extends StatelessWidget {
  final UserProfile user;

  const GlassListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: CachedNetworkImageProvider(user.imageUrl),
                ),
                const SizedBox(width: 16.0),
                Text(
                  user.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
