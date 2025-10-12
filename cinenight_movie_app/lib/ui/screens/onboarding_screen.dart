import 'dart:async';

import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/core/theme/app_fonts.dart';
import 'package:cinenight_movie_app/ui/screens/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  List<Map<String, String>> slides = [
    {
      "image": "assets/images/logo/login.jpg",
      "title": "wel_onboard1",
      "subtitle": "sub_onboard1",
    },
    {
      "image": "assets/images/logo/start2.jpg",
      "title": "wel_onboard2",
      "subtitle": "sub_onboard2",
    },
    {
      "image": "assets/images/logo/start3.jpg",
      "title": "wel_onboard3",
      "subtitle": "sub_onboard3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(slide["image"]!, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 280,
                    left: 30,
                    right: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          slide["title"]!.tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          slide["subtitle"]!.tr(),
                          style: TextStyle(
                            fontSize: 21,
                            color: const Color.fromARGB(150, 255, 255, 255),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          //start button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: slides.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.button,
                      dotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button2,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 120,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "get_start".tr(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.roboto,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
