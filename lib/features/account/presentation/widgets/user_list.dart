import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/features/account/domain/entities/user_interaction_entity.dart';

class UserProfile {
  final String imageUrl;
  final String username;
  final String advertisement;

  UserProfile({
    required this.imageUrl,
    required this.username,
    required this.advertisement,
  });
}

class UserList extends StatelessWidget {
  final List<UserInteractionEntity> userInteractionList;

  const UserList({super.key, required this.userInteractionList});

  @override
  Widget build(BuildContext context) {
    final List<UserProfile> users = userInteractionList
        .map((userInteraction) => UserProfile(
              imageUrl: userInteraction.user.profileImage!,
              username: userInteraction.user.name,
              advertisement: userInteraction.advertisement,
            ))
        .toList();

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis, // handle overflow
                      ),
                      const SizedBox(height: 4.0), // add space between texts
                      Text(
                        "🌟${user.advertisement}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis, // handle overflow
                      ),
                    ],
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
