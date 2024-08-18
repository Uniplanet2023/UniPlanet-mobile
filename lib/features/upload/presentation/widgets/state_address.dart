import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:uniplanet/features/upload/presentation/widgets/city_address.dart';

class StateSelectionPage extends StatefulWidget {
  final Function({
    required String state,
    required String city,
    required String address,
    required String zipCode,
  }) setAddress;
  final String rootFrom;
  const StateSelectionPage(
      {super.key, required this.setAddress, required this.rootFrom});

  @override
  StateSelectionPageState createState() => StateSelectionPageState();
}

class StateSelectionPageState extends State<StateSelectionPage> {
  final TextEditingController stateController = TextEditingController();
  Map<String, List<String>> stateCityMap = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String response =
        await rootBundle.loadString('assets/state_city_map.json');
    final Map<String, dynamic> data = json.decode(response);

    setState(() {
      stateCityMap =
          data.map((key, value) => MapEntry(key, List<String>.from(value)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select State')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: TypeAheadField<String>(
          suggestionsCallback: (pattern) async {
            return stateCityMap.keys
                .where(
                  (state) =>
                      state.toLowerCase().contains(pattern.toLowerCase()),
                )
                .toList();
          },
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Select State',
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
                builder: (context) => CitySelectionPage(
                  rootFrom: widget.rootFrom,
                  state: suggestion,
                  stateCityMap: stateCityMap,
                  setAddress: widget.setAddress,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
