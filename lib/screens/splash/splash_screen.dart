// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:quiz_app/screens/auth/signin_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../onboarding/onboarding_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() { // state بتاعتى
//     super.initState(); //تُنفَّذ مرة واحدة فقط عند فتح الصفحة.
//     _navigateNext();
//   }

//   Future<void> _navigateNext() async {
//     final prefs = await SharedPreferences.getInstance();
//     final bool? seenOnboarding = prefs.getBool('onboarding');
//     final bool? isLoggedIn = prefs.getBool('isLoggedIn');

//     Timer(const Duration(seconds: 5), () {

//       if (seenOnboarding == null || seenOnboarding == true) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const OnboardingScreen()),
//         );
//       }

//       else if (isLoggedIn == null || isLoggedIn == false) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const SigninScreen()),
//         );
//       }
//          //  ✅ لو مسجل دخول فعلاً SplashScreen
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.pink[50],
//       body: Center(
//         child: Lottie.asset(
//           'assets/animations/Flowers.json',
//           height: 250,
//           width: 250,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:quiz_app/screens/auth/signin_screen.dart';
// import 'package:quiz_app/screens/home/main_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../onboarding/onboarding_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateNext();
//   }

//   Future<void> _navigateNext() async {
//     final prefs = await SharedPreferences.getInstance();
//     final bool? seenOnboarding = prefs.getBool('onboarding');
//     final bool? isLoggedIn = prefs.getBool('isLoggedIn');

//     Timer(const Duration(seconds: 5), () {
//       // أول مره يفتح -> onboarding
//       if (seenOnboarding == null || seenOnboarding == true) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//         );
//         return;
//       }

//       // شاف onboarding لكن مش عامل تسجيل
//       if (isLoggedIn == null || isLoggedIn == false) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const SigninScreen()),
//         );
//         return;
//       }

//       // عامل تسجيل دخول
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const MainScreen()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.pink[50],
//       body: Center(
//         child: Lottie.asset(
//           'assets/animations/Flowers.json',
//           height: 250,
//           width: 250,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/screens/auth/signin_screen.dart';
import 'package:quiz_app/screens/home/main_navigation.dart';
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
    final prefs = await SharedPreferences.getInstance();

    final bool? seenOnboarding = prefs.getBool('onboarding'); // false = لسه مشفش
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');

    Timer(const Duration(seconds: 4), () {
      // لو *لسه مشفش* Onboarding
      if (seenOnboarding == null || seenOnboarding == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
        return;
      }

      // لو شاف Onboarding بس مش عامل Login
      if (isLoggedIn == null || isLoggedIn == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SigninScreen()),
        );
        return;
      }

      // لو عامل Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
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
