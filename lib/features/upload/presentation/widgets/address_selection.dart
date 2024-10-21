import 'package:flutter/material.dart';

class AddressSelection extends StatelessWidget {
  final String? address;
  final String? city;
  final String? stateAddress;
  final String? zipCode;
  final Function onTap;

  const AddressSelection({
    super.key,
    this.address,
    this.city,
    this.stateAddress,
    this.zipCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                city == null
                    ? 'Address'
                    : '$address, $city, $stateAddress, $zipCode',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
