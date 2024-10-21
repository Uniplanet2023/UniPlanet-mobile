import 'package:flutter/material.dart';
import 'package:uniplanet/core/utils/constant/job.dart';

class SelectJobIndustriesPage extends StatefulWidget {
  const SelectJobIndustriesPage({super.key});

  @override
  SelectJobIndustriesPageState createState() => SelectJobIndustriesPageState();
}

class SelectJobIndustriesPageState extends State<SelectJobIndustriesPage> {
  String? selectedIndustry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Job Industry'),
      ),
      body: ListView(
        children: JobConstant.jobIndustries.map((industry) {
          return ListTile(
            title: Text(industry),
            trailing: selectedIndustry == industry
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              setState(() {
                selectedIndustry = industry;
              });
              Navigator.pop(context, industry); // Return the selected industry
            },
          );
        }).toList(),
      ),
    );
  }
}
