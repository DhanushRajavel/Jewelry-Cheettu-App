import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/constants.dart';
import 'package:sms/screens/home_screen.dart';
import 'package:sms/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = 'splash_screen'; // Set static ID for navigation

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate a delay for splash screen
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate based on login state
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom Icon (Image)
            Image.asset(
              'images/logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            // Custom Text
            Text('SMS Jewelry App', style: kSplashScreenStyle()),
          ],
        ),
      ),
    );
  }
}
