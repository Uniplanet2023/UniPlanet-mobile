import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/category/presentation/blocs/free_product/free_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/buying/wanted_product_bloc.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';
import 'package:uniplanet/features/auth/presention/blocs/product/product_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    bool? isMySchool = _prefsHelper.getBool('isMySchool');
    selectedSchool =
        (isMySchool == null || !isMySchool) ? 'All School' : 'My School';
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
                DropdownButton<String>(
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
                        const LoadFreeProductEvent(category: 'Free Products'));
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
              ],
            ),
            SizedBox(
              height: 38.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    showCheckmark: false,
                    side: const BorderSide(
                        color: GlobalVariables
                            .secondaryColor), // Change border line color
                    selectedColor: GlobalVariables.secondaryColor,
                    elevation: 3,
                    label: Text(
                      'All Items',
                      style: TextStyle(
                        fontSize: isSmallDevice ? 12 : 15,
                        color: widget.choiceCheapSelected == "All Items"
                            ? Colors.white
                            : Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    selected: widget.choiceCheapSelected == "All Items",
                    onSelected: (bool selected) {
                      widget.onChoiceChanged("All Items");
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    side: const BorderSide(
                        color: GlobalVariables
                            .secondaryColor), // Change border line color
                    selectedColor: GlobalVariables.secondaryColor,
                    showCheckmark: false,
                    label: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.squareYoutube,
                          size: isSmallDevice ? 12 : 15,
                          color: widget.choiceCheapSelected == "Free Products"
                              ? Colors.white
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          ' Free Items',
                          style: TextStyle(
                            fontSize: isSmallDevice ? 12 : 15,
                            color: widget.choiceCheapSelected == "Free Products"
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    elevation: 3,
                    selected: widget.choiceCheapSelected == "Free Products",
                    onSelected: (selected) {
                      widget.onChoiceChanged("Free Products");
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    side: const BorderSide(
                        color: GlobalVariables
                            .secondaryColor), // Change border line color
                    selectedColor: GlobalVariables.secondaryColor,
                    showCheckmark: false,
                    label: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.fire,
                          size: isSmallDevice ? 12 : 15,
                          color: widget.choiceCheapSelected == "Hot Items"
                              ? Colors.white
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          ' Hot Items',
                          style: TextStyle(
                            fontSize: isSmallDevice ? 12 : 15,
                            color: widget.choiceCheapSelected == "Hot Items"
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    elevation: 3,
                    selected: widget.choiceCheapSelected == "Hot Items",
                    onSelected: (selected) {
                      widget.onChoiceChanged("Hot Items");
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    side: const BorderSide(
                        color: GlobalVariables
                            .secondaryColor), // Change border line color
                    selectedColor: GlobalVariables.secondaryColor,
                    showCheckmark: false,
                    label: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.moneyBill1,
                          size: isSmallDevice ? 12 : 15,
                          color: widget.choiceCheapSelected == "Buying"
                              ? Colors.white
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          ' Wanted to Buy',
                          style: TextStyle(
                            fontSize: isSmallDevice ? 12 : 15,
                            color: widget.choiceCheapSelected == "Buying"
                                ? Colors.white
                                : Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    elevation: 3,
                    selected: widget.choiceCheapSelected == "Buying",
                    onSelected: (selected) {
                      widget.onChoiceChanged("Buying");
                    },
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
