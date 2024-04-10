import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/account/screens/user_profile.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class UserHeader extends StatefulWidget {
  final User currentUser;
  const UserHeader({super.key, required this.currentUser});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  File? image;

  void selectImage(BuildContext context) async {
    // image = await pickImages(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              user: widget.currentUser,
            ),
          ),
        );
      },
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: GlobalVariables.backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'user-pfp',
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.currentUser.profileImage ??
                          'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const VerticalDivider(
                  width: 20,
                  thickness: 1,
                  indent: 5,
                  endIndent: 0,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.currentUser.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(widget.currentUser.email),
                      Text(
                        widget.currentUser.school,
                        style: TextStyle(color: Colors.grey[600]),
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
