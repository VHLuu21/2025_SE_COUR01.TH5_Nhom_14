import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'dart:ui';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), //làm mờ nền
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.message.withValues(
              alpha: 0.2,
            ),
            elevation: 0,
            selectedItemColor: AppColors.items,
            unselectedItemColor: Colors.white,
            currentIndex: currentIndex,
            onTap: onTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home), 
                label: "home".tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "search2".tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "wishlist".tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "profile".tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
