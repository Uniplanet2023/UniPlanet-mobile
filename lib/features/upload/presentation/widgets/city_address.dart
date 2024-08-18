import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:uniplanet/features/upload/presentation/widgets/detail_address.dart';

class CitySelectionPage extends StatelessWidget {
  final String state;
  final Function({
    required String state,
    required String city,
    required String address,
    required String zipCode,
  }) setAddress;
  final Map<String, List<String>> stateCityMap;
  final String rootFrom;
  const CitySelectionPage(
      {super.key,
      required this.state,
      required this.stateCityMap,
      required this.setAddress,
      required this.rootFrom});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select City')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: TypeAheadField(
          suggestionsCallback: (pattern) async {
            return stateCityMap[state]!
                .where(
                  (city) => city.toLowerCase().contains(pattern.toLowerCase()),
                )
                .toList();
          },
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Select City',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            );
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSelected: (suggestion) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressEntryPage(
                  rootFrom: rootFrom,
                  state: state,
                  city: suggestion,
                  setAddress: setAddress,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
