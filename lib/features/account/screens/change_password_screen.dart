import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/common/widgets/custom_button.dart';
import 'package:uniplanet/common/widgets/custom_textfield.dart';

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
  bool passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _updatePasswordConfirmController.addListener(_validatePasswordsMatch);
  }

  void _validatePasswordsMatch() {
    if (_updatePasswordController.text ==
        _updatePasswordConfirmController.text) {
      if (!passwordsMatch) {
        setState(() {
          passwordsMatch = true;
        });
      }
    } else {
      if (passwordsMatch) {
        setState(() {
          passwordsMatch = false;
        });
      }
    }
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
              borderColor: passwordsMatch
                  ? Colors.green
                  : null, // Apply green border if passwords match
            ),
            const SizedBox(height: 10),
            const Text('Confirm new password:'),
            CustomTextField(
              controller: _updatePasswordConfirmController,
              hintText: 'Confirm New Password',
              obscureText: true,
              borderColor: passwordsMatch
                  ? Colors.green
                  : null, // Apply green border if passwords match
            ),
            const SizedBox(height: 10),
            Center(
              child: FlutterPwValidator(
                  controller: _updatePasswordController,
                  minLength: 8,
                  uppercaseCharCount: 1,
                  lowercaseCharCount: 2,
                  numericCharCount: 1,
                  specialCharCount: 1,
                  width: 350,
                  height: 150,
                  defaultColor: Theme.of(context).colorScheme.tertiary,
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
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              text: 'Save',
              onTap: () => {
                if (validPassword && passwordsMatch)
                  {updatePassword(), Navigator.of(context).pop()}
              },
            ),
          ],
        ),
      ),
    );
  }
}
