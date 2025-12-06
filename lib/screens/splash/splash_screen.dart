import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/screens/auth/signin_screen.dart';
import 'package:quiz_app/widgets/home_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../onboarding/onboarding_screen.dart';

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
    // الانتظار 4 ثواني قبل الانتقال
    await Future.delayed(const Duration(seconds: 8));

    final prefs = await SharedPreferences.getInstance();
    final bool? seenOnboarding = prefs.getBool('onboarding');
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (seenOnboarding == null || seenOnboarding == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    if (isLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeWrapper()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SigninScreen()),
      );
    }
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
