import 'package:cinenight_movie_app/core/theme/app_fonts.dart';
import 'package:cinenight_movie_app/ui/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //Delay 3s
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/logo/background.jpeg", fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.8)),
          Center(child: Image.asset("assets/images/logo/logo.png", width: 200)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40, left: 10, right: 10),
              child: Text(
                "Enjoy the gathering of all movie",
                style: TextStyle(
                  fontFamily: AppFonts.roboto,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: const Color.fromARGB(255, 82, 82, 82),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
