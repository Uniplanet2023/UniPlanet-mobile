import 'package:provider/provider.dart';

import 'package:uniplanet_mobile/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/providers/user_provider.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);

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
                Provider.of<UserProvider>(context, listen: false).clearUser();
                UserRepository().logOut(context);
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
