import 'package:flutter/material.dart';

class ProductTypeToggle extends StatelessWidget {
  final String type;
  final Function(String) onTypeChanged;

  const ProductTypeToggle({
    super.key,
    required this.type,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ToggleButtons(
        borderColor: Colors.transparent,
        fillColor: Colors.transparent,
        selectedColor: Theme.of(context).colorScheme.tertiary,
        color: Theme.of(context).colorScheme.tertiary,
        borderWidth: 0,
        selectedBorderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        onPressed: (int index) {
          if (index == 0) {
            onTypeChanged('For Sale');
          } else if (index == 1) {
            onTypeChanged('Free Item');
          } else if (index == 2) {
            onTypeChanged('Buying');
          } else {
            onTypeChanged('Housing');
          }
        },
        isSelected: [
          type == 'For Sale',
          type == 'Free Item',
          type == 'Buying',
          type == 'Housing',
        ],
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: type == 'For Sale'
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.tertiaryFixedDim),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              'For Sale',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: type == 'For Sale'
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: type == 'Free Item'
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.tertiaryFixedDim),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              'Free Item',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: type == 'Free Item'
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: type == 'Buying'
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.tertiaryFixedDim),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              'Wanted to buy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: type == 'Buying'
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: type == 'Housing'
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.tertiaryFixedDim),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              'Housing',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: type == 'Housing'
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
