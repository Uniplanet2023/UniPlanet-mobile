import 'package:flutter/material.dart';

class AdvertisementTypeToggle extends StatelessWidget {
  final String type;
  final Function(String) onTypeChanged;

  const AdvertisementTypeToggle({
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
            onTypeChanged('Advertisement');
          } else if (index == 1) {
            onTypeChanged('Housing');
          } else if (index == 2) {
            onTypeChanged('Offer');
          } else if (index == 3) {
            onTypeChanged('Job');
          }
        },
        isSelected: [
          type == 'Advertisement',
          type == 'Housing',
          type == 'Offer',
          type == 'Job',
        ],
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: type == 'Advertisement'
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.tertiaryFixedDim),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              'Advertisement',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: type == 'Advertisement'
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
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
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: type == 'Offer'
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.tertiaryFixedDim),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              'Offer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: type == 'Offer'
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: type == 'Job'
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.tertiaryFixedDim),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              'Job',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: type == 'Job'
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
