import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class OtpVerifyScreen extends StatefulWidget {
  static const String routeName = '/opt-verify-screen';
  final String? email;
  final String? otpHash;
  final String? password;
  final String? name;
  final String? profileImage;
  final String? school;
  final bool? verified;

  const OtpVerifyScreen(
      {super.key,
      this.email,
      this.otpHash,
      this.name,
      this.password,
      this.profileImage,
      this.school,
      this.verified});

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

      print(res);
      if (res == "Success") {
        await UserRepository().signUpUser(
            context: context,
            verified: true,
            name: widget.name!,
            password: widget.password!,
            email: widget.email!,
            profileImage: widget.profileImage!,
            school: widget.school!);
      } else if (res == "OTP expired") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('OTP expired'),
        ));
      } else if (res == "Invalid Verfication number") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid Verfication number'),
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
              TextFormField(
                controller: _otpController,
                maxLength: 5,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Verification number',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black38,
                    )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black38,
                    ))),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Enter your verification number';
                  }
                  return null;
                },
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
