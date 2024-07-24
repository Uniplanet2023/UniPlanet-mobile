import 'package:flutter/material.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';

class CategorySelection extends StatelessWidget {
  final String type;
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategorySelection({
    super.key,
    required this.type,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: (type == 'Housing'
                ? GlobalVariables.housingCategories
                : GlobalVariables.categories)
            .map((category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    selectedColor:
                        Theme.of(context).colorScheme.primaryFixedDim,
                    label: Text(category['name']),
                    selected: selectedCategory == category['name'],
                    onSelected: (selected) {
                      if (selected) {
                        onCategoryChanged(category['name']);
                      }
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}
