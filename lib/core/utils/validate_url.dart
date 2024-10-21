bool validateUrl(String url) {
  // This regular expression is lenient and allows many valid URL formats.
  final RegExp urlPattern = RegExp(
    r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
  );
  return urlPattern.hasMatch(url);
}
