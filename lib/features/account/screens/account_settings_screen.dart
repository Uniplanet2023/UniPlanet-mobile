import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc_event.dart';

import 'package:uniplanet_mobile/bloc/auth/auth_state/basic_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/logout_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogOutCompleteState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.authPage, (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Settings'),
        ),
        body: Center(
          child: CustomButton(
              text: "Logout",
              onTap: () => context.read<AuthBloc>().add(const LogoutEvent())),
        ),
      ),
    );
  }
}
