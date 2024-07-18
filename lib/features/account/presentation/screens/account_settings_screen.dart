import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/theme/theme_cubit.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';
import 'package:uniplanet/features/account/presentation/screens/change_password_screen.dart';
import 'package:uniplanet/core/network/notification/local_notification.dart';
import 'package:uniplanet/features/account/presentation/widgets/menu_section.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';

import '../../../../config/theme/theme.dart';

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
  bool notify = false;
  bool theme = false;
  @override
  void initState() {
    super.initState();
    checkNotification();
  }

  void checkNotification() async {
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    bool? isNotificationAllowed = prefsHelper.getBool('isNotificationAllowed');
    if (isNotificationAllowed == null) {
      prefsHelper.saveBool('isNotificationAllowed', false);
      isNotificationAllowed = false;
    }
    notify = isNotificationAllowed;

    setState(() {});
  }

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  final WidgetStateProperty<Icon?> displayIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.dark_mode_outlined);
      }
      return const Icon(Icons.light_mode_outlined);
    },
  );

  void updateName(String newName) {
    getIt<AccountBloc>().add(UpdateNameEvent(name: newName));
  }

  void updatePassword(String currentPassword, String newPassword) {
    getIt<AuthBloc>().add(UpdatePasswordEvent(
        password: currentPassword, newPassword: newPassword));
  }

  void updateNotification(bool currentState) async {
    notify =
        await LocalNotificationController.notificationRationale(currentState);
    setState(() {});
  }

  void updateTheme(bool currentTheme) async {
    final cubit = getIt<ThemeCubit>();

    theme = !theme;

    cubit.toggleTheme();
  }

  @override
  void dispose() {
    _updateNameController.dispose();
    _updatePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()),
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
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        updateNotification(value);
                      },
                    ),
                    ontap: () {},
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
                "Display Theme",
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
                  BlocBuilder<ThemeCubit, ThemeData>(
                    builder: (context, state) {
                      bool isDarkMode = state == darkMode;
                      return MenuSection(
                        title: 'Appearance',
                        icon: Icons.light_mode_outlined,
                        transition: Switch(
                          thumbIcon: displayIcon,
                          value: isDarkMode,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (bool value) {
                            updateTheme(value);
                          },
                        ),
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
