import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/account/account_bloc.dart';
import 'package:uniplanet/bloc/auth/auth_bloc.dart';
import 'package:uniplanet/common/routes/names.dart';
import 'package:uniplanet/features/account/screens/account_settings_screen.dart';
import 'package:uniplanet/features/account/screens/help_screen.dart';
import 'package:uniplanet/features/account/screens/inventory_products_screen.dart';
import 'package:uniplanet/features/account/screens/liked_products_screen.dart';
import 'package:uniplanet/features/account/screens/sold_products_screen.dart';
import 'package:uniplanet/features/account/widgets/menu_section.dart';
import 'package:uniplanet/features/account/widgets/user_header.dart';
import 'package:uniplanet/features/widgets/terms_and_policies.dart';
import 'package:uniplanet/models/user.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final User currentUser;
    currentUser = context.watch<AccountBloc>().state.account.user;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 245, 252),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 239, 252),
        title: const Text('My Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
        child: Column(
          children: [
            UserHeader(
              currentUser: currentUser,
            ), // User info widget
            const SizedBox(
              height: 30,
            ),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  MenuSection(
                    title: 'My Listings',
                    icon: Icons.inventory_sharp,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventoryProductsScreen(
                            user: currentUser,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 0.1,
                    height: 5,
                  ),
                  MenuSection(
                    title: 'Sold Products',
                    icon: Icons.history,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SoldProductsScreen(
                            user: currentUser,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 0.1,
                    height: 5,
                  ),
                  MenuSection(
                    title: 'Liked Products',
                    icon: Icons.favorite_border_sharp,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LikedProductsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 0.1,
                    height: 5,
                  ),
                  MenuSection(
                    title: 'Account Settings',
                    icon: Icons.settings,
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
                      title: "Terms and Policies",
                      icon: Icons.info_outlined,
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsAndPolicies(),
                          ),
                        );
                      }),

                  const Divider(
                    thickness: 0.1,
                    height: 5,
                  ),

                  MenuSection(
                    title: 'Sign out',
                    icon: Icons.exit_to_app,
                    ontap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BlocListener<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is LogOutCompleteState) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    AppRoutes.authPage, (route) => false);
                              }
                            },
                            child: AlertDialog(
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
                                  onPressed: () => context
                                      .read<AuthBloc>()
                                      .add(const LogoutEvent()),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ), // Menu section widget
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Uniplanet LLC.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("Version 1.0")
          ],
        ),
      ),
    );
  }
}
