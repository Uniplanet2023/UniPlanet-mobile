import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
//core
import 'package:uniplanet/core/entities/user_type.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/constant/university_list.dart';
//common
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';
//auth feature
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';
import 'package:uniplanet/features/auth/functions/signup.dart';
import 'package:uniplanet/features/auth/presention/screens/phone_opt_verify_screen.dart';
import 'package:uniplanet/features/auth/presention/widgets/bezier_container.dart';
import 'package:uniplanet/features/auth/presention/widgets/terms_and_conditions.dart';
import 'package:uniplanet/features/auth/presention/widgets/us_number_format.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? school = "";
  bool validPassword = false;
  bool isChecked = false;
  UserType userType = UserType.student;
  bool isPhoneVerified = false;
  bool isOtpSent = false;

  String selectedCountryCode = '+1';
  String verificationId = "";

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
  }

  Future<void> verifyPhoneNumber() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String phoneNumber =
        '$selectedCountryCode${_phoneController.text.replaceAll('-', '')}';
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        setState(() {
          isPhoneVerified = true;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Verification failed")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
          isOtpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  Future<bool> verifyOtp(String otpCode) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );
      await auth.signInWithCredential(credential);
      setState(() {
        isPhoneVerified = true;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Theme.of(context).colorScheme.tertiary,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Theme.of(context).colorScheme.secondaryFixedDim;
      }
      return Theme.of(context).colorScheme.secondaryFixedDim;
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignupSuccessState) {
          Navigator.pushNamed(context, AppRoutes.otpVerifyPage,
              arguments: _emailController.text);
        } else if (state is OTPValidationCompleteState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.authPage, (Route<dynamic> route) => false);
        } else if (state is SignupFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup failed. Please try again.')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryFixedDim,
        body: Stack(
          children: [
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Lottie.asset('assets/animations/signup.json',
                            width: 300),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Please sign up to continue',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: userType == UserType.student
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryFixedDim,
                              ),
                              child: TextButton.icon(
                                onPressed: () =>
                                    setState(() => userType = UserType.student),
                                icon: const Icon(Icons.school),
                                label: const Text('Student'),
                                style: TextButton.styleFrom(
                                  foregroundColor: userType == UserType.student
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: userType == UserType.local
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryFixedDim,
                              ),
                              child: TextButton.icon(
                                onPressed: () =>
                                    setState(() => userType = UserType.local),
                                icon: const Icon(Icons.home),
                                label: const Text('Local'),
                                style: TextButton.styleFrom(
                                  foregroundColor: userType == UserType.local
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: userType == UserType.advertiser
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryFixedDim,
                              ),
                              child: TextButton.icon(
                                onPressed: () => setState(
                                    () => userType = UserType.advertiser),
                                icon: const Icon(Icons.campaign),
                                label: const Text('Advertiser'),
                                style: TextButton.styleFrom(
                                  foregroundColor: userType ==
                                          UserType.advertiser
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _nameController,
                          hintText: userType == UserType.advertiser
                              ? "Company Name"
                              : 'Name',
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _emailController,
                          hintText: userType == UserType.student
                              ? 'Email (.edu only)'
                              : 'Email',
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: selectedCountryCode,
                                items: <String>['+1', '+82']
                                    .map((code) => DropdownMenuItem<String>(
                                          value: code,
                                          child: Text(code),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCountryCode = value!;
                                  });
                                },
                                underline: Container(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  NumberTextInputFormatter(
                                      countryCode: selectedCountryCode),
                                ],
                                enabled:
                                    !isPhoneVerified, // Disable the TextField when phone is verified
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            isPhoneVerified
                                ? const Icon(Icons.verified,
                                    color: Colors.green)
                                : ElevatedButton(
                                    onPressed: () {
// Remove any non-digit characters from the phone number
                                      String cleanPhoneNumber = _phoneController
                                          .text
                                          .replaceAll(RegExp(r'\D'), '');
                                      if (cleanPhoneNumber.length >= 10) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PhoneOTPVerifyScreen(
                                                      onVerification:
                                                          verifyPhoneNumber,
                                                      onVerificationComplete:
                                                          verifyOtp)),
                                        );
                                        // Your verify phone number logic here
                                        verifyPhoneNumber();
                                      } else {
                                        // Show an error message if the phone number is not 10 digits
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please enter a valid 10-digit or 11-digit phone number.'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 12.0),
                                    ),
                                    child: const Text('Verify'),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DropdownSearch<String>(
                          popupProps: const PopupProps.menu(
                              showSearchBox: true,
                              showSelectedItems: true,
                              scrollbarProps: ScrollbarProps(
                                trackBorderColor: Colors.amber,
                              )),
                          items: universities,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: userType == UserType.advertiser
                                  ? "Select School Where You Want To Advertise"
                                  : "Select School",
                              focusColor: Theme.of(context).colorScheme.primary,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryFixedDim,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              school = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          isPassword: true,
                        ),
                        const SizedBox(height: 10),
                        FlutterPwValidator(
                            controller: _passwordController,
                            minLength: 8,
                            uppercaseCharCount: 1,
                            lowercaseCharCount: 2,
                            numericCharCount: 1,
                            specialCharCount: 1,
                            width: 350,
                            height: 150,
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Theme.of(context).colorScheme.primary,
                              fillColor:
                                  WidgetStateProperty.resolveWith(getColor),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            const Expanded(
                              child: TermsAndConditions(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is SignupState) {
                              return const CircularProgressIndicator();
                            }
                            return CustomButton(
                              text: 'Sign Up',
                              onTap: () {
                                if (_signUpFormKey.currentState!.validate() &&
                                    isPhoneVerified) {
                                  if (userType == UserType.student) {
                                    studentSignUpUser(
                                        context,
                                        _emailController.text,
                                        _nameController.text,
                                        school,
                                        validPassword,
                                        _passwordController.text,
                                        _phoneController.text,
                                        isChecked,
                                        userType);
                                  } else {
                                    signUpUser(
                                        context,
                                        _emailController.text,
                                        _nameController.text,
                                        school,
                                        validPassword,
                                        _passwordController.text,
                                        _phoneController.text,
                                        isChecked,
                                        userType);
                                  }
                                } else if (!isPhoneVerified) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Phone not verified.')),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account? '),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
