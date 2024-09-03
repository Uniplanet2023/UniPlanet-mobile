import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:uniplanet/core/local_stoarage/shared_preferences_helper.dart';

class TutorialHelper {
  final BuildContext context;
  final GlobalKey dropdownKey;
  final GlobalKey allItemsKey;
  final GlobalKey freeItemsKey;
  final GlobalKey hotItemsKey;
  final GlobalKey wantedToBuyKey;
  TutorialCoachMark?
      tutorialCoachMark; // Store the instance of TutorialCoachMark

  TutorialHelper({
    required this.context,
    required this.dropdownKey,
    required this.allItemsKey,
    required this.freeItemsKey,
    required this.hotItemsKey,
    required this.wantedToBuyKey,
  });

  void startTutorial() {
    SharedPreferencesHelper.instance.saveBool('first_home_user', true);

    List<TargetFocus> targets = [
      TargetFocus(
        identify: "DropdownButton",
        keyTarget: dropdownKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "\n\nTap here to choose between viewing all schools or just your school.",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    tutorialCoachMark?.next(); // Proceed to the next target
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "AllItemsChoiceChip",
        keyTarget: allItemsKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "\n\nTap here to view all items available.",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    tutorialCoachMark?.next(); // Proceed to the next target
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "FreeItemsChoiceChip",
        keyTarget: freeItemsKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "\n\nTap here to filter and view only free items.",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    tutorialCoachMark?.next(); // Proceed to the next target
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "HotItemsChoiceChip",
        keyTarget: hotItemsKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "\n\nTap here to filter and view the hottest items.",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    tutorialCoachMark?.next(); // Proceed to the next target
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "WantedToBuyChoiceChip",
        keyTarget: wantedToBuyKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "\n\nTap here to view items that people want to buy.",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    tutorialCoachMark?.finish(); // Finish the tutorial
                  },
                  child: const Text("Finish"),
                ),
              ],
            ),
          ),
        ],
      ),
    ];

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 0,
      opacityShadow: 0.8,
    );

    tutorialCoachMark!.show(context: context);
  }
}
