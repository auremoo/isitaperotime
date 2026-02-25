import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailServiceProvider =
    Provider<EmailService>((ref) => EmailService());

class EmailService {
  static const String developerEmail = 'moote.pro@gmail.com';

  Future<bool> sendContactEmail({
    required String senderName,
    required String message,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: developerEmail,
      queryParameters: {
        'subject': 'Is it Apero Time - Contact de $senderName',
        'body': message,
      },
    );

    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return false;
  }

  Future<bool> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
