import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:uniplanet/common/functions/open_gallery.dart';
import 'package:uniplanet/features/account/screens/inventory_products_screen.dart';
import 'package:uniplanet/features/account/screens/sold_products_screen.dart';
import 'package:uniplanet/features/product_details/screens/seller_inventory_screen.dart';
import 'package:uniplanet/features/product_details/screens/seller_sold_products_screen.dart';
import 'package:uniplanet/models/user_model.dart';
import 'package:uniplanet/api/repository/auth_repository/auth_repo.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Coachmark
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  int tutorialStep = 0;
  bool hasSeenTutorial = true;

  GlobalKey listingKey = GlobalKey();
  GlobalKey soldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hasSeenTutorial = prefs.getBool('hasSeenProfileTutorial') ?? false;
    if (!hasSeenTutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _showTutorial();
        });
      });
      prefs.setBool('hasSeenProfileTutorial', true);
    }
  }

  _showTutorial() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8,
        onSkip: () {
          return true;
        },
        onFinish: () {},
        onClickTarget: (target) {})
      ..show(context: context);
  }

  void _initTarget() {
    targets = [
      TargetFocus(
        identify: "listing-key",
        keyTarget: listingKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text: "Tap here to view all the products listed by the user!",
                  skip: 'Skip',
                  next: 'Next',
                  onNext: () {
                    controller.next();
                  },
                  onSkip: () {
                    tutorialCoachMark?.finish();
                  },
                );
              })
        ],
        shape: ShapeLightFocus.RRect,
      ),
      TargetFocus(
        identify: "sold-key",
        keyTarget: soldKey,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return CoachmarkDesc(
                  text:
                      "Tap here to check out the products that have been sold by the user!",
                  skip: 'Skip',
                  next: 'Next',
                  onSkip: () {
                    tutorialCoachMark?.finish();
                  },
                );
              })
        ],
        shape: ShapeLightFocus.RRect,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Lottie.asset('assets/animations/background.json',
              fit: BoxFit.cover),
        ),
        SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90.h,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          openGallery(context, 1, [widget.user.profileImage!]);
                        },
                        child: Hero(
                          tag: 'user-pfp',
                          child: CircleAvatar(
                            radius: 60
                                .w, // Assuming you have defined 'w' somewhere as a width factor
                            backgroundImage: CachedNetworkImageProvider(
                                widget.user.profileImage!),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        widget.user.name,
                        style: TextStyle(
                            fontSize: 0.09.sw,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.user.email,
                        style:
                            TextStyle(color: Colors.white, fontSize: 0.04.sw),
                      ),
                      Text(
                        widget.user.school,
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 0.04.sw),
                      ),
                      SizedBox(
                        height: 40.h,
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
                  "Items available for sale by ${widget.user.name}",
                  widget.user.id == AuthRepository.userId
                      ? InventoryProductsScreen(
                          user: widget.user,
                        )
                      : SellerProductsScreen(
                          user: widget.user,
                        ),
                  Icons.inventory_sharp,
                  listingKey,
                ),
                SizedBox(
                  height: 5.h,
                ),
                items(
                    context,
                    "Sold",
                    "./assets/images/sold.jpeg",
                    "Previously sold items by ${widget.user.name}",
                    widget.user.id == AuthRepository.userId
                        ? SoldProductsScreen(
                            user: widget.user,
                          )
                        : SellerSoldProductsScreen(
                            user: widget.user,
                          ),
                    Icons.history,
                    soldKey),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent, // AppBar transparent
            elevation: 0, // No shadow
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ]),
    );
  }
}

Widget items(BuildContext context, String name, String image,
    String description, Widget screen, IconData icon, GlobalKey key) {
  return Padding(
    key: key,
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
        color: Colors.transparent,
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
                      color: Colors.white,
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
                            color: Colors.white,
                          ),
                        ),
                        // Add some spacing between the title and the subtitle
                        Container(height: 5.h),
                        // Add a subtitle widget
                        Text(
                          "Check Out!",
                          style: TextStyle(
                            color: Colors.grey[300],
                          ),
                        ),
                        // Add some spacing between the subtitle and the text
                        Container(height: 10.h),
                        // Add a text widget to display some text
                        Text(
                          description,
                          maxLines: 2,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 16),
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

class CoachmarkDesc extends StatefulWidget {
  final String text;
  final String skip;
  final String next;
  final Function? onSkip;
  final Function? onNext;

  const CoachmarkDesc({
    super.key,
    required this.text,
    this.skip = 'Skip',
    this.next = 'Next',
    this.onSkip,
    this.onNext,
  });

  @override
  State<CoachmarkDesc> createState() => CoachmarkDescState();
}

class CoachmarkDescState extends State<CoachmarkDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(widget.text,
              style: const TextStyle(fontSize: 20, color: Colors.white)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  if (widget.onSkip != null) {
                    widget.onSkip!();
                  }
                },
                child: Text(widget.skip),
              ),
              TextButton(
                onPressed: () {
                  if (widget.onNext != null) {
                    widget.onNext!();
                  } else {
                    widget.onSkip!();
                  }
                },
                child: Text(widget.next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
