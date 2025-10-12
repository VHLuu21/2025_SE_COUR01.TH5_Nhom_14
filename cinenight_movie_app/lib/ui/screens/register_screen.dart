import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/core/theme/app_fonts.dart';
import 'package:cinenight_movie_app/data/db_service.dart';
import 'package:cinenight_movie_app/ui/screens/login_screen.dart';
import 'package:cinenight_movie_app/ui/widgets/snackbar_show.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isChecked = false;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Kiểm tra người dùng tick vào checkbox
    if (!_isChecked) {
      setState(() {
        _isLoading = false;
      });
      SnackbarShow().showCustomSnackBar("agree_term".tr(), false, context);
      return;
    }

    try {
      final con = await DbService.connect();

      // Kiểm tra email tồn tại
      var result = await con.execute(
        "SELECT * FROM users WHERE email = :email",
        {"email": email},
      );

      //Nếu tồn tại đưa ra thông báo lỗi
      if (result.numOfRows > 0) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        SnackbarShow().showCustomSnackBar("check_email".tr(), false, context);
        return;
      }

      //Nếu không tồn tại lưu tài khoản đăng kí lên DB
      await con.execute(
        "INSERT INTO users(email, name, password) VALUES (:email, :name, :password)",
        {"email": email, "name": username, "password": password},
      );
      //Đóng kết nối tới DB
      await con.close();

      setState(() => _isLoading = false);
      if (!mounted) return;
      SnackbarShow().showCustomSnackBar("register_success".tr(), true, context);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
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
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.button2,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Tiêu đề hello
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "wel_register".tr(),
                      style: TextStyle(
                        fontSize: 35,
                        color: AppColors.items,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.montserrat,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

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
                    //Kiểm tra email hợp lệ
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
                  const SizedBox(height: 15),

                  //Username
                  Padding(
                    padding: EdgeInsets.only(left: 3, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "name".tr(),
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
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "ex_hint_name".tr(),
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
                    //Kiểm tra trường nhập tên
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "valid_name".tr();
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
                    //Kiểm tra password hợp lệ
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return "valid_password".tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  //Confirm password
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
                    // Kiểm tra confirm password hợp lệ
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
                  const SizedBox(height: 10),
                  //Checkbox điều kiện và điều khoản
                  CheckboxListTile(
                    title: Text(
                      "confirm_condition".tr(),
                      style: TextStyle(
                        color: AppColors.button2,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.montserrat,
                      ),
                    ),
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.button2,
                    checkColor: Colors.white,
                    contentPadding: EdgeInsets.only(left: 0),
                  ),
                  const SizedBox(height: 10),

                  //Nút đăng kí và loading
                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.button2,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _signup();
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
                              "register".tr(),
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
