import 'package:flutter/material.dart';

import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/account/widgets/menu_section.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController _updateNameController = TextEditingController();
  final TextEditingController _updatePasswordController =
      TextEditingController();

  bool validPassword = false;
  bool notify = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  void updateName(String newName) {}
  void updatePassword(String newPassword) {}

  @override
  void dispose() {
    _updateNameController.dispose();
    _updatePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.greyBackgroundCOlor,
        title: const Text('Account Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  MenuSection(
                    title: 'Change Name',
                    icon: Icons.manage_accounts_outlined,
                    ontap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Change Name'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Enter a new name:'),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  controller: _updateNameController,
                                  hintText: 'Enter a new name',
                                )
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Save'),
                                onPressed: () {
                                  updateName(_updateNameController.text);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const Divider(
                    thickness: 0.1,
                    height: 5,
                  ),
                  MenuSection(
                    title: 'Change Password',
                    icon: Icons.password_outlined,
                    // screen: PaymentScreen(),
                    ontap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Change Password'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Enter a new password:'),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  controller: _updatePasswordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                ),
                                const SizedBox(height: 10),
                                FlutterPwValidator(
                                    controller: _updatePasswordController,
                                    minLength: 8,
                                    uppercaseCharCount: 1,
                                    lowercaseCharCount: 2,
                                    numericCharCount: 1,
                                    specialCharCount: 1,
                                    width: 350,
                                    height: 150,
                                    defaultColor: Colors.black,
                                    onSuccess: () {
                                      setState(() {
                                        validPassword = true;
                                      });
                                    },
                                    onFail: () {
                                      setState(() {
                                        validPassword = false;
                                      });
                                    }),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Save'),
                                onPressed: () {
                                  updatePassword(
                                      _updatePasswordController.text);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: const Text(
                "Notifications",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  MenuSection(
                    title: 'Enable/Disable Notifications',
                    icon: Icons.notifications_outlined,
                    transition: Switch(
                      thumbIcon: thumbIcon,
                      value: notify,
                      activeColor: GlobalVariables.secondaryColor,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          notify = value;
                        });
                      },
                    ),
                    ontap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
