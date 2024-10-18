import 'package:flutter/material.dart';
import 'package:sms/screens/help_screen.dart';
import 'package:sms/screens/home_screen.dart';
import 'package:sms/screens/join_plan_screen.dart';
import 'package:sms/screens/login_screen.dart';
import 'package:sms/screens/multi_product_screen.dart';
import 'package:sms/screens/my_profile.dart';
import 'package:sms/screens/signup_screen.dart';
import 'package:sms/screens/transaction_screen.dart';
import 'package:sms/screens/my_plan_screen.dart';
import 'package:sms/screens/payment_screen.dart';
import 'package:sms/screens/splash_screen.dart'; // Import the SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id, // Set SplashScreen as the initial route
      routes: {
        SplashScreen.id: (context) => const SplashScreen(), // Splash screen route
        HomeScreen.id: (context) => const HomeScreen(),
        JoinPlanScreen.id: (context) => const JoinPlanScreen(),
        MyPlanScreen.id: (context) => const MyPlanScreen(),
        TransactionScreen.id: (context) => const TransactionScreen(),
        PaymentScreen.id: (context) => const PaymentScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignupScreen.id: (context) => const SignupScreen(),
        MultiProductScreen.id: (context) => const MultiProductScreen(),
        MyProfile.id: (context) => const MyProfile(),
        HelpScreen.id: (context) => const HelpScreen(),
      },
    );
  }
}
