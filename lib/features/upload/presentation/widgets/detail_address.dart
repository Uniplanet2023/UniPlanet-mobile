import 'package:flutter/material.dart';
import 'package:uniplanet/features/upload/presentation/widgets/post_number_address.dart';

class AddressEntryPage extends StatelessWidget {
  final String state;
  final String city;
  final Function({
    required String state,
    required String city,
    required String address,
    required String zipCode,
  }) setAddress;
  final String rootFrom;
  const AddressEntryPage(
      {super.key,
      required this.state,
      required this.city,
      required this.setAddress,
      required this.rootFrom});

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Address')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'State: $state\nCity: $city',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Enter Address',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostNumberEntryPage(
                          state: state,
                          city: city,
                          address: addressController.text,
                          setAddress: setAddress,
                          rootFrom: rootFrom,
                        ),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
