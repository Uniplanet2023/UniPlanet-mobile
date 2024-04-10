import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
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

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedFile!.path);
    });
    if (pickedFile != null) {
      // Show confirmation dialog

      bool confirmUpload = await showUploadConfirmationDialog();
      if (confirmUpload) {
        // Here you could upload the image to your server and then update the user's profile image URL
        //// For example: uploadImage(image);
        SnackbarGlobal.key.currentContext!
            .read<AccountBloc>()
            .add(UpdateProfileImageEvent(image: image!));
      } else {
        setState(() {
          image = null;
        });
      }
    }
  }

  Future<bool> showUploadConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Image'),
              content: const Text(
                  'Are you sure you want to upload this image as your profile picture?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Upload'),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if the dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
              GestureDetector(
                onTap: selectImage,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Hero(
                      tag: 'user-pfp',
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: image != null
                            ? FileImage(image!) as ImageProvider
                            : CachedNetworkImageProvider(
                                widget.currentUser.profileImage ??
                                    'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg',
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0, // Adjust the position based on your UI needs
                      bottom: 0, // Adjust the position based on your UI needs
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors
                            .grey[700], // Choose the color that fits your app
                        size: 24, // Adjust the size based on your UI needs
                      ),
                    ),
                  ],
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
    );
  }
}
