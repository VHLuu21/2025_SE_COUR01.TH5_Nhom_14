import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/core/theme/app_fonts.dart';
import 'package:cinenight_movie_app/data/userpref.dart';
import 'package:cinenight_movie_app/data/db_service.dart';
import 'package:cinenight_movie_app/ui/screens/forgotpw_screen.dart';
import 'package:cinenight_movie_app/ui/screens/main_screen.dart';
import 'package:cinenight_movie_app/ui/screens/onboarding_screen.dart';
import 'package:cinenight_movie_app/ui/screens/register_screen.dart';
import 'package:cinenight_movie_app/ui/widgets/snackbar_show.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      final con = await DbService.connect();

      //Kiểm tra tài khoản với db
      var result = await con.execute(
        "SELECT * FROM users WHERE email = :email AND password = :password",
        {"email": email, "password": password},
      );
      await con.close();

      setState(() {
        _isLoading = false;
      });

      if (result.numOfRows > 0) {
        //Lấy tên user đăng nhập
        final row = result.rows.first;
        String? name = row.colByName("name");
        await Userpref.saveName(name ?? "");

        //Lấy id người dùng trên db và chuyển thành kiểu số nguyên
        String? rawId = row.colByName("id");
        int? userId = int.tryParse(rawId ?? "");

        if (userId != null) {
          await Userpref.saveId(userId);
        }

        if (!mounted) return;
        SnackbarShow().showCustomSnackBar("login_success".tr(), true, context);
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false,
        );
      } else {
        if (!mounted) return;
        SnackbarShow().showCustomSnackBar("invalid".tr(), false, context);
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
  Widget build(BuildContext content) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Icon back
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.button2,
                          child: IconButton(
                            //Thêm hành động bấm vào quay lại màn hình Onboarding
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OnboardingScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  //Tiêu đề welcome
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "wel_login".tr(),
                      style: TextStyle(
                        fontSize: 35,
                        color: AppColors.items,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.montserrat,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),

                  //Các trường nhập thông tin
                  //Email
                  Padding(
                    padding: EdgeInsets.only(left: 3, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            fontSize: 16,
                            color: AppColors.fieldtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    //Kiểm tra tính hợp lệ của Email nhập vào
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "valid_email".tr();
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return "valid_email".tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  //Password
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
                    //Kiểm tra tính hợp lệ của Password
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return "valid_password".tr();
                      }
                      return null;
                    },
                  ),

                  //Forgot password
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotpwScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "forgot".tr(),
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.items,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  //Nút đăng nhập và loading
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
                                _login();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.button2,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "login".tr(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.montserrat,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  //Chuyển hướng sang màn hình đăng kí
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "no_account".tr(),
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "register".tr(),
                          style: TextStyle(
                            color: AppColors.items,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
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
