import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/api_response.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class OtpVerifyScreen extends StatefulWidget {
  static const String routeName = '/opt-verify-screen';
  final String? email;
  final String? otpHash;

  const OtpVerifyScreen({super.key, this.email, this.otpHash});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpFormKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  void verifyUser(BuildContext context) async {
    if (widget.email != null && widget.otpHash != null) {
      String res = await UserRepository().verifyUser(
          context: context,
          email: widget.email!,
          otpHash: widget.otpHash!,
          otpCode: _otpController.text);

      if (res == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Account verified!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Email address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        color: GlobalVariables.backgroundColor,
        child: Form(
          key: _otpFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                width: 200,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Enter the verification number sent to your Email address to continue:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomTextField(
                controller: _otpController,
                hintText: 'Verification number',
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Submit',
                onTap: () {
                  if (_otpFormKey.currentState!.validate()) {
                    verifyUser(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
