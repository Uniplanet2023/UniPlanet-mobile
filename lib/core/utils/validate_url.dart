bool validateUrl(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }

  // Regular expression to check if the input is a valid URL
  String pattern =
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$';
  RegExp regExp = RegExp(pattern);

  if (!regExp.hasMatch(value)) {
    return false;
  }

  return true;
}
