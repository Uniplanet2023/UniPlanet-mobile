import 'package:uniplanet_mobile/constants/utils.dart';

void resetPassword(ressetPassword) {
  try {
    final bool emailValid = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.+-]+\.edu$")
        .hasMatch(ressetPassword);

    if (!emailValid || ressetPassword == '') {
      SnackbarGlobal.showSnackBar(
        'Email format not correct, only school accounts accepted(.edu)',
      );
      return;
    }
    // UserRepository().forgottenPassword(
    //     context: context, email: _resetPasswordController.text);
  } catch (e) {
    SnackbarGlobal.showSnackBar(
      'Something went wrong',
    );
  }
}
