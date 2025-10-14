import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

Future<void> emailService({
  required String toEmail,
  required String otpCode,
}) async {
  // Thông tin tài khoản email gửi
  final String yourEmail = dotenv.env['EMAIL_ADDRESS'] ?? '';
  final String appPassWord = dotenv.env['EMAIL_APP_PASSWORD'] ?? '';

  final smtpServer = gmail(yourEmail, appPassWord);

  //Đọc file HTML template
  final htmlStyle = await rootBundle.loadString('assets/email_style/otp_style.html');

  //Thay thế placeholder bằng OTP code
  final otpCodeHtml = htmlStyle.replaceAll('{{otp}}', otpCode);

  // Nội dung gửi
  final message = Message()
   ..from = Address(yourEmail, 'CineNight')
   ..recipients.add(toEmail)
   ..subject = 'Your OTP Code'
   ..html = otpCodeHtml;
try {
  await send(message, smtpServer);
} on MailerException catch (e) {
  print('Error: $e');
}

}
