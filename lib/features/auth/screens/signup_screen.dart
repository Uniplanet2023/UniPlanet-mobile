import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/auth/widgets/terms_and_conditions.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';
import 'package:uniplanet_mobile/constants/university_list.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup-screen';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SignupScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? school = "";
  bool validPassword = false;

  bool isChecked = false;

  void signUpUser(BuildContext context) async {
    final bool emailValid = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.+-]+\.edu$")
        .hasMatch(_emailController.text);

    if (isChecked == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Agree to Terms and conditions to continue'),
      ));
      return;
    }

    if (school == null || school == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select school before continuing!'),
      ));
      return;
    }

    if (!emailValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Email format not correct, only school accounts accepted(.edu)'),
      ));
      return;
    }
    if (!validPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password not in a valid format!'),
      ));
      return;
    }

    await UserRepository().sendOtp(
        context: context,
        email: _emailController.text,
        name: _nameController.text,
        verified: true,
        password: _passwordController.text,
        profileImage:
            'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg',
        school: school!);
  }

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

    return Scaffold(
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
                      signUpUser(context);
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
    );
  }
}
