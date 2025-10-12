import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/core/theme/app_fonts.dart';
import 'package:cinenight_movie_app/data/verifyotp.dart';
import 'package:cinenight_movie_app/ui/screens/login_screen.dart';
import 'package:cinenight_movie_app/ui/widgets/snackbar_show.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ResetpwScreen extends StatefulWidget {
  final int userId;
  const ResetpwScreen({super.key, required this.userId});
  @override
  State<ResetpwScreen> createState() => _ResetpwScreenState();
}

class _ResetpwScreenState extends State<ResetpwScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  Future<void> setNewPassWord() async {
    setState(() {
      _isLoading = true;
    });

    String newPassword = _passwordController.text.trim();

    try {
      String stringId = widget.userId.toString();
      await Verifyotp().updatePassword(stringId, newPassword);
      if (!mounted) return;
      SnackbarShow().showCustomSnackBar("update_success".tr(), true, context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (routes) => false,
      );
    } catch (e) {
      if (!mounted) return;
      SnackbarShow().showCustomSnackBar("connection_error".tr(), false, context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
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
                  SizedBox(
                    child: CircleAvatar(
                      backgroundColor: AppColors.button2,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (routes) => false,
                          );
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "set_new_pw".tr(),
                    style: TextStyle(
                      color: AppColors.button2,
                      fontFamily: AppFonts.montserrat,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "title_reset".tr(),
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      fontFamily: AppFonts.montserrat,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.only(left: 3, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "password".tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.roboto,
                            fontSize: 16,
                            color: AppColors.fieldtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "********",
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(179, 47, 46, 46),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return "valid_password".tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(left: 3, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "confirm_password".tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.roboto,
                            fontSize: 16,
                            color: AppColors.fieldtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _confirmpasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "********",
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(179, 47, 46, 46),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return "valid_confirm_password".tr();
                      }
                      if (value != _passwordController.text) {
                        return "valid_match".tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "note_reset_pw_1".tr(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: AppFonts.montserrat,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "note_reset_pw_2".tr(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: AppFonts.montserrat,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "note_reset_pw_3".tr(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: AppFonts.montserrat,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "note_reset_pw_4".tr(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: AppFonts.montserrat,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setNewPassWord();
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
                              "update_pw".tr(),
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
