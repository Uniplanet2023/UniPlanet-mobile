import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uniplanet/constants/global_variables.dart';

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
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      snap: false,
      floating: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      toolbarHeight: Platform.isAndroid ? 122.h : 90.h,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.only(
            left: 10, top: Platform.isAndroid ? 40 : 50, bottom: 0),
        title: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 5),
                const Image(
                    image: AssetImage('assets/images/Logo_nbg.png'),
                    width: 30,
                    height: 30),
                Text('UniPlanet',
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    )
                    // style: GoogleFonts.satisfy(
                    //     fontSize: 17,
                    //     color: Colors.black,
                    //     fontWeight: FontWeight.w600),
                    ),
              ],
            ),
            SizedBox(
              height: 60,
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
                          size: 15,
                          color: widget.choiceCheapSelected == "Free Products"
                              ? Colors.white
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          ' Free Items',
                          style: TextStyle(
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
                      // Navigator.pushNamed(context, AppRoutes.category,
                      //     arguments: 'Free Products');
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
                          size: 15,
                          color: widget.choiceCheapSelected == "Hot Items"
                              ? Colors.white
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          ' Hot Items',
                          style: TextStyle(
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
                          size: 15,
                          color: widget.choiceCheapSelected == "Buying"
                              ? Colors.white
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          ' Wanted to Buy',
                          style: TextStyle(
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
