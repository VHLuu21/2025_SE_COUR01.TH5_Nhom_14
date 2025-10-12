

import 'package:url_launcher/url_launcher.dart';

class UrHelper {
  static Future<void> launchURL(String url) async{
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Không mở được $url');
  }
}
}