import 'package:flutter/material.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _buttonText = 'Send Reset Link';
  bool _isSent = false;

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      getIt<AuthBloc>().add(ResetPasswordEvent(email: _emailController.text));
      // Implement your logic to send a reset password email
      log('Sending reset password link to: ${_emailController.text}');
      setState(() {
        _isSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your email address to receive a password reset link.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  // Add more complex email validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isSent
                  ? const Text(
                      'Sent',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    )
                  : CustomButton(
                      text: _buttonText,
                      onTap: _resetPassword,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
