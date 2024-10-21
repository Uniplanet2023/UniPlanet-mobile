import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/category/presentation/blocs/free_product/free_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/buying/wanted_product_bloc.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/local_stoarage/shared_preferences_helper.dart';
import 'package:uniplanet/features/upload/presentation/blocs/product/product_bloc.dart';
import 'package:uniplanet/features/home/presentation/funcions/school_tutorial.dart';

class HomeHeader extends StatefulWidget {
  final String choiceCheapSelected;
  final Function(String) onChoiceChanged;
  const HomeHeader({
    super.key,
    required this.choiceCheapSelected,
    required this.onChoiceChanged,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();
  String selectedSchool = 'All School'; // Default selected value
  final GlobalKey _dropdownKey = GlobalKey(); // Key for the DropdownButton
  final GlobalKey _allItemsKey =
      GlobalKey(); // Key for the All Items ChoiceChip
  final GlobalKey _freeItemsKey =
      GlobalKey(); // Key for the Free Items ChoiceChip
  final GlobalKey _hotItemsKey =
      GlobalKey(); // Key for the Hot Items ChoiceChip
  final GlobalKey _wantedToBuyKey =
      GlobalKey(); // Key for the Wanted to Buy ChoiceChip
  final GlobalKey _housingKey =
      GlobalKey(); // Key for the Wanted to housing ChoiceChip
  final GlobalKey _jobKey = GlobalKey(); // Key for the Wanted to job ChoiceChip
  final GlobalKey _offerKey =
      GlobalKey(); // Key for the Wanted to offer ChoiceChip
  @override
  void initState() {
    super.initState();
    bool? isMySchool = _prefsHelper.getBool('isMySchool');
    selectedSchool =
        (isMySchool == null || !isMySchool) ? 'All School' : 'My School';
    bool? isFirstHomeUser =
        SharedPreferencesHelper.instance.getBool('first_home_user');
    if (isFirstHomeUser == null || isFirstHomeUser == false) {
      // Start the tutorial after the widget tree has been built

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1)).then((_) {
          if (mounted) {
            TutorialHelper(
              context: context,
              dropdownKey: _dropdownKey,
              allItemsKey: _allItemsKey,
              freeItemsKey: _freeItemsKey,
              hotItemsKey: _hotItemsKey,
              wantedToBuyKey: _wantedToBuyKey,
              housingKey: _housingKey,
              jobKey: _jobKey,
              offerKey: _offerKey,
            ).startTutorial();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallDevice =
        screenHeight < 800; // Threshold for small devices like iPhone SE

    double textSize =
        isSmallDevice ? 15 : 20; // Adjust text size for small devices
    double imageHeight = Platform.isAndroid
        ? 100.0
        : (screenHeight > 1000
            ? 130.0
            : isSmallDevice
                ? 100.0
                : 85.0); // Adjust for iPad and iPhone SE
    double titlePaddingTop = Platform.isAndroid
        ? 40.0
        : isSmallDevice
            ? 20.0
            : 45.0;
    double imageWidth = isSmallDevice
        ? 20.0
        : (screenWidth > 600
            ? 40.0
            : 30.0); // Adjust the image width for small devices and screen width

    return SliverAppBar(
      pinned: false,
      snap: false,
      floating: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      toolbarHeight: imageHeight,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.only(
            left: 10, top: titlePaddingTop, bottom: 0, right: 10),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Image(
                      image: const AssetImage('assets/images/Logo_nbg.png'),
                      width: imageWidth,
                      height: imageWidth,
                    ),
                    Text('UniPlanet',
                        style: TextStyle(
                          fontSize: textSize, // Use the adjusted font size
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                GestureDetector(
                  key: _dropdownKey,
                  child: DropdownButton<String>(
                    value: selectedSchool,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: isSmallDevice ? 12 : 15,
                      fontWeight: FontWeight.w600,
                    ),
                    items: <String>['All School', 'My School']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      bool isMySchool = newValue == 'My School';
                      getIt<ProductBloc>().add(const LoadProductEvent());
                      getIt<FreeProductBloc>().add(
                          const LoadFreeProductEvent(category: 'Free Items'));
                      context
                          .read<HotProductBloc>()
                          .add(const LoadHotProductsEvent());
                      context
                          .read<WantedProductBloc>()
                          .add(const LoadWantedProductEvent());
                      _prefsHelper.saveBool('isMySchool', isMySchool);
                      setState(() {
                        selectedSchool = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 38.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  HomeChoiceChip(
                    globalKey: _allItemsKey,
                    isSmallDevice: isSmallDevice,
                    widget: widget,
                    category: "All Items",
                    icon: null,
                  ),
                  const SizedBox(width: 10),
                  HomeChoiceChip(
                    globalKey: _offerKey,
                    isSmallDevice: isSmallDevice,
                    widget: widget,
                    category: "Offers",
                    icon: Icons.discount_rounded,
                  ),
                  const SizedBox(width: 10),
                  HomeChoiceChip(
                    globalKey: _freeItemsKey,
                    isSmallDevice: isSmallDevice,
                    widget: widget,
                    category: "Free Items",
                    icon: FontAwesomeIcons.gift,
                  ),
                  const SizedBox(width: 10),
                  HomeChoiceChip(
                    globalKey: _housingKey,
                    isSmallDevice: isSmallDevice,
                    widget: widget,
                    category: "Housing",
                    icon: FontAwesomeIcons.house,
                  ),
                  const SizedBox(width: 10),
                  HomeChoiceChip(
                    globalKey: _jobKey,
                    isSmallDevice: isSmallDevice,
                    widget: widget,
                    category: "Job",
                    icon: FontAwesomeIcons.briefcase,
                  ),
                  const SizedBox(width: 10),
                  HomeChoiceChip(
                    globalKey: _hotItemsKey,
                    isSmallDevice: isSmallDevice,
                    widget: widget,
                    category: "Hot Items",
                    icon: FontAwesomeIcons.fire,
                  ),
                  const SizedBox(width: 10),
                  HomeChoiceChip(
                    globalKey: _wantedToBuyKey,
                    isSmallDevice: isSmallDevice,
                    widget: widget,
                    category: "Buying",
                    icon: FontAwesomeIcons.moneyBill,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeChoiceChip extends StatelessWidget {
  const HomeChoiceChip({
    super.key,
    required this.globalKey,
    required this.isSmallDevice,
    required this.widget,
    required this.category,
    required this.icon,
  });

  final GlobalKey<State<StatefulWidget>> globalKey;
  final bool isSmallDevice;
  final HomeHeader widget;
  final String category;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      key: globalKey, // Assign the key for the Free Items ChoiceChip
      padding: const EdgeInsets.symmetric(vertical: 0),
      side: const BorderSide(
          color: GlobalVariables.secondaryColor), // Change border line color
      selectedColor: GlobalVariables.secondaryColor,
      showCheckmark: false,
      label: Row(
        children: [
          icon != null
              ? Row(
                  children: [
                    FaIcon(
                      icon,
                      size: isSmallDevice ? 12 : 15,
                      color: widget.choiceCheapSelected == category
                          ? Colors.white
                          : Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 3)
                  ],
                )
              : const SizedBox(),
          Text(
            category,
            style: TextStyle(
              fontSize: isSmallDevice ? 12 : 15,
              color: widget.choiceCheapSelected == category
                  ? Colors.white
                  : Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
      selected: widget.choiceCheapSelected == category,
      onSelected: (selected) {
        widget.onChoiceChanged(category);
      },
    );
  }
}
