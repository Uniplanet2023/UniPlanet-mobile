class UniServices {
  static String _code = '';
  static String get code => _code;
  static bool get hsaCode => _code.isNotEmpty;

  static void reset() => _code = '';

  static uniHandler(Uri? uri) {
    if (uri == null || uri.queryParameters.isEmpty) return;
  }
}
