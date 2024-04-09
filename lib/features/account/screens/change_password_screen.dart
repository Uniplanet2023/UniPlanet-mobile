import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _updatePasswordController =
      TextEditingController();
  final TextEditingController _updatePasswordConfirmController =
      TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  bool validPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _updatePasswordController.dispose();
    _updatePasswordConfirmController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  void updatePassword() {
    context.read<AuthBloc>().add(UpdatePasswordEvent(
        password: _currentPasswordController.text,
        newPassword: _updatePasswordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.greyBackgroundCOlor,
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your current password:'),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _currentPasswordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            const Text('Enter a new password:'),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _updatePasswordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            const Text('Confirm new password:'),
            CustomTextField(
              controller: _updatePasswordConfirmController,
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
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (validPassword) {
                  updatePassword();
                  Navigator.of(context).pop();
                } else {
                  // Show some error message
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
