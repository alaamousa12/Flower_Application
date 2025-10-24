import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/screens/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? seenOnboarding = prefs.getBool('onboarding');
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');

    Timer(const Duration(seconds: 5), () {
      // ✅ أول مرة: روح للـ Onboarding
      if (seenOnboarding == null || seenOnboarding == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
      // ✅ لو شاف Onboarding لكن مش عامل تسجيل دخول
      else if (isLoggedIn == null || isLoggedIn == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninScreen()),
        );
      }
      // ✅ لو مسجل دخول فعلاً
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
