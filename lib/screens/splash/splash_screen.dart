import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inflights_pro/base/res/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home page after a delay
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(130, 20, 24, 1), // Background color
      body: Center(
        child: Image.asset(
          'assets/images/splash.png', // Path to your logo
          width: 500, // Adjust the width as needed
          height: 500, // Adjust the height as needed
        ),
      ),
    );
  }
}
