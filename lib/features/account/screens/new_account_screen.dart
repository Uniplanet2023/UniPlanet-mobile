import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/features/account/screens/account_settings_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/app_settings_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/buying_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/help_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/payment_screen.dart';
import 'package:uniplanet_mobile/features/account/screens/selling_screen.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class NewAccountScreen extends StatelessWidget {
  const NewAccountScreen({Key? key}) : super(key: key);

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
  const UserHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserRepository.getUser(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // Placeholder pfp
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
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
    );
  }
}

class MenuSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget screen;
  const MenuSection(
      {Key? key, required this.title, required this.icon, required this.screen})
      : super(key: key);

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
