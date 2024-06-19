import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:uniplanet/bloc/auth/auth_bloc.dart';
import 'package:uniplanet/common/routes/names.dart';
import 'package:uniplanet/common/widgets/custom_button.dart';
import 'package:uniplanet/common/widgets/custom_textfield.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/features/auth/functions/signup.dart';
import 'package:uniplanet/features/auth/widgets/bezier_container.dart';
import 'package:uniplanet/features/auth/widgets/terms_and_conditions.dart';
import 'package:uniplanet/constants/university_list.dart';

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

  String? school = "";
  bool validPassword = false;
  bool isChecked = false;
  bool isStudent = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
              child: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
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
        return Colors.white;
      }
      return Colors.white;
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
                                color: isStudent
                                    ? GlobalVariables.secondaryColor
                                    : Colors.grey[200],
                              ),
                              child: TextButton.icon(
                                onPressed: () =>
                                    setState(() => isStudent = true),
                                icon: const Icon(Icons.school),
                                label: const Text('Student'),
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      isStudent ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: !isStudent
                                    ? GlobalVariables.secondaryColor
                                    : Colors.grey[200],
                              ),
                              child: TextButton.icon(
                                onPressed: () =>
                                    setState(() => isStudent = false),
                                icon: const Icon(Icons.campaign),
                                label: const Text('Advertiser'),
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      !isStudent ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _nameController,
                          hintText: 'Name',
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _emailController,
                          hintText: isStudent ? 'Email (.edu only)' : 'Email',
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
                              hintText: isStudent
                                  ? "Select School"
                                  : "Select School Where You Want To Advertise",
                              focusColor: GlobalVariables.secondaryColor,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black38,
                                ),
                                borderRadius: BorderRadius.all(
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
                              checkColor: GlobalVariables.secondaryColor,
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
                                if (_signUpFormKey.currentState!.validate()) {
                                  signUpUser(
                                      context,
                                      _emailController.text,
                                      _nameController.text,
                                      school,
                                      validPassword,
                                      _passwordController.text,
                                      isChecked,
                                      isStudent);
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
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.secondaryColor,
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
