
import 'package:cinenight_movie_app/ui/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screen = const [
    HomeScreen(),
    SearchScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _screen[_currentIndex],
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavigation(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}
