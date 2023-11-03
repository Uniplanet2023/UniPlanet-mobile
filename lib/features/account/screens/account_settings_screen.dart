import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/statusBloc/status_bloc.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  void logout(BuildContext context) {
    context.read<UserBloc>().add(LogoutEvent(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Center(
        child: CustomButton(text: "Logout", onTap: () => logout(context)),
      ),
    );
  }
}
