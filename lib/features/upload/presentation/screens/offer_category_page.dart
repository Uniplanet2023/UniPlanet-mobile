import 'package:flutter/material.dart';
import 'package:uniplanet/core/utils/constant/service.dart';

class SelectServiceCategory extends StatefulWidget {
  const SelectServiceCategory({super.key});

  @override
  SelectServiceCategoryState createState() => SelectServiceCategoryState();
}

class SelectServiceCategoryState extends State<SelectServiceCategory> {
  String? selectedIndustry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: ListView(
        children: ServiceCategory.serviceCategory.map((service) {
          return ListTile(
            title: Text(service['name']!),
            trailing: selectedIndustry == service
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              setState(() {
                selectedIndustry = service['name']!;
              });
              Navigator.pop(context, service); // Return the selected industry
            },
          );
        }).toList(),
      ),
    );
  }
}
