import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';
import 'package:uniplanet/features/account/presentation/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Your Orders',
              onTap: () {},
            ),
            AccountButton(
              text: 'Turn Seller',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: 'Log Out',
              onTap: () {
                getIt<AuthBloc>().add(const LogoutEvent());
              },
            ),
            AccountButton(
              text: 'Your Wish List',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
