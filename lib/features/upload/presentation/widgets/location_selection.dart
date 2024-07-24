import 'package:flutter/material.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';

class LocationSelection extends StatelessWidget {
  final String selectedLocation;
  final Function(String) onLocationChanged;

  const LocationSelection({
    super.key,
    required this.selectedLocation,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: GlobalVariables.locations
            .map((location) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    selectedColor:
                        Theme.of(context).colorScheme.primaryFixedDim,
                    label: Text(location),
                    selected: selectedLocation == location,
                    onSelected: (selected) {
                      if (selected) {
                        onLocationChanged(location);
                      }
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}
