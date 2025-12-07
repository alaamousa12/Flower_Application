import 'package:flutter/material.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/Payment/payment_success.dart';
import '../screens/Payment/payment_failure.dart';
import '../screens/Payment/add_card.dart';
import '../screens/Payment/payment_method.dart';
import '../screens/help center/help_center_screen.dart';
import '../screens/help center/contactus_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Favorites Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      home: const HelpCenterScreen(), // ← هنا شاشة الفيفوريت الجديدة
    );
  }
}
