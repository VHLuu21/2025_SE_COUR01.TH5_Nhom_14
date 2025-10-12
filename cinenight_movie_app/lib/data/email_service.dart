import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

Future<void> emailService({
  required String toEmail,
  required String otpCode,
}) async {
  // Email account information
  const String yourEmail = 'your_email@gmail.com';
  const String appPassWord = 'your_password';

  final smtpServer = gmail(yourEmail, appPassWord);

  final message = Message()
   ..from = Address(yourEmail, 'CineNight')
   ..recipients.add(toEmail)
   ..subject = 'Your OTP Code'
   ..text = 'Your verification code is: $otpCode'
   ..html = '''
    <h3>Hello</h3>
    <p>Ma otp cua ban la: <b>$otpCode</b></p>
''';
try {
  await send(message, smtpServer);
} on MailerException catch (e) {
  print('Error: $e');
}

}
