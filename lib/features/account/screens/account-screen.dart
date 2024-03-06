import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/features/account/screens/account_settings_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/app_settings_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/buying_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/help_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/payment_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/selling_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            UserHeader(), // User info widget
            MenuSection(
              title: 'Buying',
              icon: Icons.shopping_bag_outlined,
              screen: BuyingScreen(),
            ), // Menu section widget
            MenuSection(
                title: 'Selling',
                icon: Icons.sell_outlined,
                screen: SellingScreen()),
            MenuSection(
              title: 'Payment',
              icon: Icons.payment_outlined,
              screen: PaymentScreen(),
            ),
            MenuSection(
              title: 'Account Settings',
              icon: Icons.manage_accounts_outlined,
              screen: AccountSettingsScreen(),
            ),
            MenuSection(
              title: 'App Settings',
              icon: Icons.settings_outlined,
              screen: AppSettingsScreen(),
            ),
            MenuSection(
              title: 'Help',
              icon: Icons.help_outline,
              screen: HelpScreen(),
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
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    state.account.user.profileImage), // Placeholder pfp
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.account.user.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        'User ID: ${state.account.user.id}'), // Replace with actual data
                    Text(
                      'Basic description goes here.', // Replace with actual data
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MenuSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget screen;
  const MenuSection(
      {super.key,
      required this.title,
      required this.icon,
      required this.screen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        leading: Icon(icon),
        // trailing: const Icon(Icons.arrow_forward), // Replace with actual icon
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screen,
            ),
          );
        },
      ),
    );
  }
}
