import 'package:cinenight_movie_app/data/verifyotp.dart';
import 'package:cinenight_movie_app/ui/screens/resetpw_screen.dart';
import 'package:cinenight_movie_app/ui/widgets/snackbar_show.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

class VerifyScreen extends StatefulWidget {
  final String email;
  final int userId;
  const VerifyScreen({super.key, required this.email, required this.userId});

  @override
  State<VerifyScreen> createState() => _VerifyScreen();
}

class _VerifyScreen extends State<VerifyScreen> {
  String otpInput = "";
  bool _isLoading = false;

  Future<void> verifyOtpInput() async {
    if (otpInput.isEmpty) {
      SnackbarShow().showCustomSnackBar("check_otp".tr(), false, context);
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      //Kiểm tra mã OTP
      final result = await Verifyotp().verifyOtp(widget.userId, otpInput);

      if (result) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetpwScreen(userId: widget.userId),
          ),
        );
      } else {
        if (!mounted) return;
        SnackbarShow().showCustomSnackBar("invalid_otp".tr(), false, context);
      }
    } catch (e) {
      SnackbarShow().showCustomSnackBar("connection_error".tr(), false, context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  "check_email_fg".tr(),
                  style: TextStyle(
                    color: AppColors.button2,
                    fontFamily: AppFonts.montserrat,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "send_code_to".tr(),
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            fontFamily: AppFonts.montserrat,
                          ),
                        ),
                        TextSpan(
                          text: widget.email,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.montserrat,
                          ),
                        ),
                      ],
                    ),
                    softWrap: true,
                  ),
                ),

                SizedBox(height: 3),
                Text(
                  "enter_digit".tr(),
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    fontFamily: AppFonts.montserrat,
                  ),
                ),
                SizedBox(height: 40),
                //Trường nhập OTP
                Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: OtpTextField(
                    numberOfFields: 5,
                    borderColor: Color.fromARGB(255, 223, 223, 223),
                    borderRadius: BorderRadius.circular(12),
                    filled: true,
                    fillColor: Colors.white,
                    fieldWidth: 50,
                    focusedBorderColor: AppColors.button,
                    cursorColor: AppColors.button2,
                    textStyle: TextStyle(
                      fontFamily: AppFonts.montserrat,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    showFieldAsBox: true,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    onSubmit: (String code) {
                      setState(() {
                        otpInput = code;
                      });
                    },
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            _isLoading ? null : verifyOtpInput();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.button2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                          ),
                          child: Text(
                            "verify_code".tr(),
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
    );
  }
}
