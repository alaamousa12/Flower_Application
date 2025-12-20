import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/home_wrapper.dart'; // الملف المعدل
import '../auth/signin_screen.dart';
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
    // الانتظار 4 ثواني (أو حسب رغبتك)
    await Future.delayed(const Duration(seconds: 4));

    final prefs = await SharedPreferences.getInstance();
    final bool? seenOnboarding = prefs.getBool('onboarding');
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');

    // استرجاع حالة الأدمن المحفوظة
    final bool isAdmin = prefs.getBool('isAdmin') ?? false;

    if (seenOnboarding == null || seenOnboarding == false) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
      return;
    }

    if (isLoggedIn == true) {
      if (mounted) {
        // تمرير حالة الأدمن المحفوظة للـ HomeWrapper
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeWrapper(isAdmin: isAdmin),
          ),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SigninScreen()),
        );
      }
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