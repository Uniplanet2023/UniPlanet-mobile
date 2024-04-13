import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/account/screens/inventory_products_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/sold_products_screen.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;
  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.2, 0.4, 0.6, 0.8, 1],
                    colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade300,
                      Colors.orange.shade200,
                      Colors.orange.shade100,
                      Colors.orange.shade50,
                    ],
                  ),
                  color: GlobalVariables.secondaryColor,
                  image: const DecorationImage(
                    image: AssetImage('./assets/images/Logo.png'),
                    opacity: 0.05,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Hero(
                      tag: 'user-pfp',
                      child: CircleAvatar(
                        radius: 60
                            .w, // Assuming you have defined 'w' somewhere as a width factor
                        backgroundImage:
                            CachedNetworkImageProvider(user.profileImage!),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                          fontSize: 0.09.sw, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(user.email),
                    Text(
                      user.school,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Column(
                          children: [
                            // Text(
                            //   'Listings',
                            //   style: TextStyle(
                            //       fontSize: 0.05.sw,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            // Text(
                            //   '0',
                            //   style: TextStyle(
                            //     fontSize: 0.055.sw,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          width: 60.w,
                        ),
                        const Column(
                          children: [
                            // Text(
                            //   'Sold',
                            //   style: TextStyle(
                            //       fontSize: 0.05.sw,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            // Text(
                            //   '0',
                            //   style: TextStyle(
                            //     fontSize: 0.055.sw,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              items(
                  context,
                  "Listings",
                  "./assets/images/listings.jpeg",
                  "Items currently available for sale by ${user.name}",
                  InventoryProductsScreen(
                    controller: ScrollController(),
                    user: user,
                  ),
                  Icons.inventory_sharp),
              SizedBox(
                height: 5.h,
              ),
              items(
                  context,
                  "Sold",
                  "./assets/images/sold.jpeg",
                  "Previously sold items by ${user.name}",
                  SoldProductsScreen(
                    controller: ScrollController(),
                    user: user,
                  ),
                  Icons.history),
            ],
          ),
        ),
      ),
    );
  }
}

Widget items(BuildContext context, String name, String image,
    String description, Widget screen, IconData icon) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
      child: Card(
        color: Colors.orange.shade50,
        // Define the shape of the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // Define how the card's content should be clipped
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // Define the child widget of the card
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add padding around the row widget
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Add an image widget to display an image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Icon(
                      icon,
                      size: 90,
                      color: Colors.black54,
                    ),
                  ),
                  // Add some spacing between the image and the text
                  Container(width: 10.w),
                  // Add an expanded widget to take up the remaining horizontal space
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Add some spacing between the top of the card and the title
                        Container(height: 5.h),
                        // Add a title widget
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                        // Add some spacing between the title and the subtitle
                        Container(height: 5.h),
                        // Add a subtitle widget
                        Text(
                          "Check Out!",
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        // Add some spacing between the subtitle and the text
                        Container(height: 10.h),
                        // Add a text widget to display some text
                        Text(
                          description,
                          maxLines: 2,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                      ],
                    ),
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
