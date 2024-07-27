import 'package:flutter/material.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';

class HousingDetails extends StatelessWidget {
  final bool isUtilityIncluded;
  final bool isSecurityDeposit;
  final Function(bool) onUtilityChanged;
  final Function(bool) onSecurityDepositChanged;
  final TextEditingController securityDepositController;
  final String selectedGender;
  final Function(String) onGenderChanged;
  final List<String> selectedHousingConditions;
  final Function(String, bool) onHousingConditionChanged;

  const HousingDetails({
    super.key,
    required this.isUtilityIncluded,
    required this.isSecurityDeposit,
    required this.onUtilityChanged,
    required this.onSecurityDepositChanged,
    required this.securityDepositController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.selectedHousingConditions,
    required this.onHousingConditionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Switch(
                  value: isUtilityIncluded,
                  onChanged: onUtilityChanged,
                ),
                const Text('Utility Included'),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isSecurityDeposit,
                  onChanged: onSecurityDepositChanged,
                ),
                const Text('Security Deposit'),
              ],
            ),
          ],
        ),
        if (isSecurityDeposit)
          CustomTextField(
            controller: securityDepositController,
            hintText: "Security Deposit",
            enabled: true,
            maxLength: 8,
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: true),
            prefixText: '\$',
            validatorEnabled: true,
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 10),
            const Text('Gender  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Row(
              children: ['Male', 'Female', 'N/A']
                  .map((gender) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          selectedColor:
                              Theme.of(context).colorScheme.primaryFixedDim,
                          label: Text(gender),
                          selected: selectedGender == gender,
                          onSelected: (selected) {
                            if (selected) {
                              onGenderChanged(gender);
                            }
                          },
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
        const Column(
          children: [
            SizedBox(height: 20),
            Text('Housing Conditions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: GlobalVariables.housingConditions
                .map((condition) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        selectedColor:
                            Theme.of(context).colorScheme.primaryFixedDim,
                        label: Text(condition['name']),
                        selected: selectedHousingConditions
                            .contains(condition['name']),
                        onSelected: (selected) {
                          onHousingConditionChanged(
                              condition['name'], selected);
                        },
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
