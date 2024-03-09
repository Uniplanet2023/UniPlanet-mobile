import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/account/screens/account_settings_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/app_settings_screen.dart';
// import 'package:uniplanet_mobile/features/account/screens/buying_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/help_screen.dart';
// import 'package:uniplanet_mobile/features/account/screens/payment_screen.dart';
// import 'package:uniplanet_mobile/features/account/screens/selling_screen.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen> {
  final TextEditingController _updateNameController = TextEditingController();
  final TextEditingController _updatePasswordController =
      TextEditingController();

  bool validPassword = false;

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
        title: const Text('My Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 300),
        child: Column(
          children: [
            const UserHeader(), // User info widget
            const SizedBox(
              height: 30,
            ),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  // MenuSection(
                  //   title: 'Buying',
                  //   icon: Icons.shopping_bag_outlined,
                  //   screen: BuyingScreen(),
                  // ), // Menu section widget
                  // Divider(
                  //   thickness: 0.1,
                  //   height: 5,
                  // ),
                  // MenuSection(
                  //     title: 'Selling',
                  //     icon: Icons.sell_outlined,
                  //     screen: SellingScreen()),
                  // Divider(
                  //   thickness: 0.1,
                  //   height: 5,
                  // ),
                  MenuSection(
                    title: 'Change Name',
                    icon: Icons.manage_accounts_outlined,
                    // screen: AppSettingsScreen(),
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
                                    minLength: 6,
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
                  const Divider(
                    thickness: 0.1,
                    height: 5,
                  ),
                  MenuSection(
                    title: 'Account Settings',
                    icon: Icons.manage_accounts_outlined,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 0.1,
                    height: 5,
                  ),

                  MenuSection(
                      title: 'Help',
                      icon: Icons.help_outline,
                      // screen: HelpScreen(),
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpScreen(),
                          ),
                        );
                      }),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  MenuSection(
                    title: 'Sign out',
                    icon: Icons.exit_to_app,
                    // screen: BuyingScreen(),
                    ontap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Icon(
                              Icons.logout_outlined,
                              size: 50,
                            ),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sign out of your account?'),
                                SizedBox(height: 10),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text(
                                  'sign out',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ), // Menu section widget

                  const Divider(
                    thickness: 0.1,
                    height: 5,
                  ),
                  MenuSection(
                    title: 'Delete Account',
                    icon: Icons.delete_forever_outlined,
                    color: Colors.red,
                    // screen: SellingScreen(),
                    ontap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Icon(
                              Icons.warning_amber,
                              color: Colors.red,
                              size: 50,
                            ),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Are you sure?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Do you want really to delete your account? You will not be able to undo this action.',
                                  style:
                                      TextStyle(overflow: TextOverflow.visible),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
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
          ],
        ),
      ),
    );
  }
}

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: GlobalVariables.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Badge(
                alignment: Alignment.bottomRight,
                offset: Offset(-6, -6),
                label: Icon(
                  Icons.add_a_photo,
                  weight: BorderSide.strokeAlignOutside,
                  size: 18,
                  color: GlobalVariables.primaryColor,
                ),
                backgroundColor: Color.fromARGB(0, 0, 0, 0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
              ),
              const SizedBox(width: 8),
              const VerticalDivider(
                width: 20,
                thickness: 1,
                indent: 5,
                endIndent: 0,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AccountRepository.currentUser.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text('User ID: 12345'), // Replace with actual data
                    Text(
                      'Basic description goes here.', // Replace with actual data
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuSection extends StatelessWidget {
  final String title;
  final IconData icon;
  // final Widget screen;
  final Function()? ontap;
  final Color? color;
  const MenuSection(
      {super.key,
      required this.title,
      required this.icon,
      this.ontap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, color: color)),
        leading: Icon(
          icon,
          color: color,
        ),
        trailing: const Icon(Icons.arrow_forward), // Replace with actual icon
        onTap: ontap,
      ),
    );
  }
}
