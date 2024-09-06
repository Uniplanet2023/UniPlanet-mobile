import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlWithCookie(String url, String cookie) async {
  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      webViewConfiguration: WebViewConfiguration(
        headers: {'Cookie': cookie},
      ),
      mode: LaunchMode.externalApplication, // Opens in the default browser
    );
  } else {
    throw 'Could not launch $url';
  }
}
