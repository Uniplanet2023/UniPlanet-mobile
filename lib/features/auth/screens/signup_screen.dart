import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-bloc.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-state/basic-state.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-state/signup-state.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/auth/functions/signup.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/opt_verfiy_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signin_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/splash_screen.dart';
import 'package:uniplanet_mobile/features/auth/widgets/terms_and_conditions.dart';
import 'package:uniplanet_mobile/repository/auth-repository/auth-repo.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';
import 'package:uniplanet_mobile/constants/university_list.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup-screen';
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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Colors.white;
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OTPValidationRequireState) {
          Navigator.pushNamed(context, OtpVerifyScreen.routeName,
              arguments: _emailController.text);
        } else if (state is OTPValidationCompleteState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AuthScreen.routeName, (Route<dynamic> route) => false);
        } else if (state is SignupFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup failed. Please try again.')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            color: GlobalVariables.backgroundColor,
            child: Form(
              key: _signUpFormKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Logo.png',
                    width: 200,
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
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Name',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email (.edu only)',
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
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Select School",
                        focusColor: GlobalVariables.secondaryColor,
                        enabledBorder: OutlineInputBorder(
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
                  ),
                  const SizedBox(height: 10),
                  FlutterPwValidator(
                      controller: _passwordController,
                      minLength: 6,
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
                        fillColor: MaterialStateProperty.resolveWith(getColor),
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
                  CustomButton(
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
                            isChecked);
                      }
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
