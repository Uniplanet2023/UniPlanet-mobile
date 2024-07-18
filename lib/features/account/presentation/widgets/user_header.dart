import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/advertiser/advertiser_bloc.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/presentation/screens/user_profile.dart';
import 'package:uniplanet/models/account.dart';
import 'package:uniplanet/models/advertiser.dart';

class UserHeader extends StatefulWidget {
  final Account currentUser;
  const UserHeader({super.key, required this.currentUser});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  File? image;

  Future<void> selectImage() async {
    final permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted ||
        permissionStatus.isLimited ||
        Platform.isAndroid) {
      pickImage();
    } else if (permissionStatus.isPermanentlyDenied) {
      Permission.photos.request();
      openAppSettings();
    } else {
      Permission.photos.request();
      if (context.mounted) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Permission needed"),
            content: const Text("This app needs gallery access to pick images"),
            actions: <Widget>[
              TextButton(
                child: const Text("Deny"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text("Settings"),
                onPressed: () => openAppSettings(), // Open app settings
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    // Check if an image was picked
    if (pickedFile != null) {
      // Update the state to reflect the picked image
      setState(() {
        image = File(pickedFile.path);
      });

      // Show confirmation dialog
      bool confirmUpload = await showUploadConfirmationDialog();
      if (confirmUpload) {
        // Assuming 'image' is a global variable that holds the File
        // Here you could upload the image to your server and then update the user's profile image URL
        getIt<AccountBloc>().add(UpdateProfileImageEvent(image: image!));
      } else {
        // Reset the image to null if the user cancels the upload
        setState(() {
          image = null;
        });
      }
    } else {
      // Handle the case where no image is picked
      log("No image selected");
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
    Advertiser? advertiser;
    if (widget.currentUser.type == "advertiser") {
      advertiser = context.watch<AdvertiserBloc>().state.advertiser;
    }
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              user: widget.currentUser.user,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
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
                      widget.currentUser.user.profileImage == null ||
                              widget.currentUser.user.profileImage == ""
                          ? const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 60,
                              ),
                            )
                          : Hero(
                              tag: 'user-pfp',
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: image != null
                                    ? FileImage(image!) as ImageProvider
                                    : CachedNetworkImageProvider(
                                        widget.currentUser.user.profileImage!),
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
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.currentUser.user.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          widget.currentUser.type == "advertiser"
                              ? const Icon(
                                  Icons.campaign,
                                  color: GlobalVariables.secondaryColor,
                                )
                              : widget.currentUser.type == "student"
                                  ? const Icon(
                                      Icons.verified,
                                      color: GlobalVariables.secondaryColor,
                                    )
                                  : const SizedBox(),
                        ],
                      ),
                      Text(widget.currentUser.user.email),
                      Text(
                        widget.currentUser.user.school,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      widget.currentUser.type == "advertiser"
                          ? Text(
                              "My Credits: ${(advertiser!.freeCredit + advertiser.credit - advertiser.freeCreditUsed - advertiser.creditUsed).toStringAsFixed(2)}\$ ",
                              style: const TextStyle(
                                color: GlobalVariables.secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const SizedBox(),
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
