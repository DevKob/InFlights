import 'package:flutter/material.dart';
import 'package:inflights_pro/base/bottom_nav_bar.dart';
import 'package:inflights_pro/base/res/app_routes.dart';
import 'package:inflights_pro/screens/splash/splash_screen.dart'; // Import the splash screen
import 'package:inflights_pro/screens/tracker/bookmark.dart'; // Import flight tracker screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen, // Set the initial route to splash screen
      routes: {
        AppRoutes.splashScreen: (context) => const SplashScreen(), // Show splash screen first
        AppRoutes.homePage: (context) => const BottomNavBar(),
        AppRoutes.bookMark: (context) => BookmarkScreen(), // Add the flight tracker route
      },
    );
  }
}
