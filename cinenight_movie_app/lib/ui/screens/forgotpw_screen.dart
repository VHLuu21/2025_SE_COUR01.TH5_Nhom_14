import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/core/theme/app_fonts.dart';
import 'package:cinenight_movie_app/data/email_service.dart';
import 'package:cinenight_movie_app/data/verifyotp.dart';
import 'package:cinenight_movie_app/ui/screens/verify_screen.dart';
import 'package:cinenight_movie_app/ui/widgets/snackbar_show.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ForgotpwScreen extends StatefulWidget {
  const ForgotpwScreen({super.key});

  @override
  State<ForgotpwScreen> createState() => _ForgotpwScreen();
}

class _ForgotpwScreen extends State<ForgotpwScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _checkemail() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();

    try {
      //Kết nối đến DB
      final con = Verifyotp();
      String? rawId = await con.getUserIdByEmail(email);
      int? userId = int.tryParse(rawId ?? "");

      setState(() {
        _isLoading = false;
      });

      if (userId != null) {
        //Tạo OTP code lưu theo user id, đồng thời gửi email đến user id đó
        String otp = con.generateOtp();
        await con.saveOtp(userId, otp);
        emailService(toEmail: email, otpCode: otp);
        if (!mounted) return;
        SnackbarShow().showCustomSnackBar("check_email_fg".tr(), true, context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyScreen(email: email, userId: userId),
          ),
        );
      } else {
        if (!mounted) return;
        SnackbarShow().showCustomSnackBar("unregisted".tr(), false, context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      SnackbarShow().showCustomSnackBar("connection_error".tr(), false, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Icon back
                  SizedBox(
                    child: CircleAvatar(
                      backgroundColor: AppColors.button2,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  //Tiêu đề
                  Text(
                    "forgot".tr(),
                    style: TextStyle(
                      color: AppColors.button2,
                      fontFamily: AppFonts.montserrat,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "title_fg".tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontFamily: AppFonts.montserrat,
                    ),
                  ),
                  SizedBox(height: 30),

                  //Trường nhập Email
                  Text(
                    "Email",
                    style: TextStyle(
                      color: AppColors.fieldtitle,
                      fontFamily: AppFonts.montserrat,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Color.fromARGB(200, 0, 0, 0)),
                    decoration: InputDecoration(
                      hintText: "ex_hint_email".tr(),
                      hintStyle: const TextStyle(color: AppColors.logRe),
                      filled: true,
                      fillColor: AppColors.backgroundfield,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.button,
                          width: 1,
                        ),
                      ),
                    ),
                    //Kiểm tra tính hợp lệ Email nhập vào
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "valid_email".tr();
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return "valid_email".tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  //Nút gửi mã và loading
                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _checkemail();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.button2,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            child: Text(
                              "send_code".tr(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.montserrat,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
