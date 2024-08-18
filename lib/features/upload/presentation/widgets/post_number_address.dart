import 'package:flutter/material.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';

class PostNumberEntryPage extends StatelessWidget {
  final String state;
  final String city;
  final String address;
  final String rootFrom;
  final Function({
    required String state,
    required String city,
    required String address,
    required String zipCode,
  }) setAddress;

  const PostNumberEntryPage({
    super.key,
    required this.state,
    required this.city,
    required this.address,
    required this.setAddress,
    required this.rootFrom,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController postNumberController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Post Number')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'State: $state\nCity: $city\nAddress: $address',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: postNumberController,
                decoration: const InputDecoration(
                  labelText: 'Post Number',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  onTap: () {
                    setAddress(
                      state: state,
                      city: city,
                      address: address,
                      zipCode: postNumberController.text,
                    );
                    Navigator.popUntil(context, ModalRoute.withName(rootFrom));
                  },
                  text: 'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
