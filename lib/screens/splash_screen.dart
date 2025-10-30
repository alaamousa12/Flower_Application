import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/screens/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() { // state بتاعتى 
    super.initState(); //تُنفَّذ مرة واحدة فقط عند فتح الصفحة.
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? seenOnboarding = prefs.getBool('onboarding');
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');

    Timer(const Duration(seconds: 5), () {
     
      if (seenOnboarding == null || seenOnboarding == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
     
      else if (isLoggedIn == null || isLoggedIn == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninScreen()),
        );
      }
         //  ✅ لو مسجل دخول فعلاً SplashScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Lottie.asset(
          'assets/animations/Flowers.json',
          height: 250,
          width: 250,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
