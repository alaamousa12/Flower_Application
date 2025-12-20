import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../screens/home/main_navigation.dart';
import 'app_drawer.dart';

class HomeWrapper extends StatelessWidget {
  final bool isAdmin; // متغير لاستقبال الصلاحية

  // القيمة الافتراضية false (مستخدم عادي)
  const HomeWrapper({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: ZoomDrawer(
        menuScreen: const AppDrawer(),
        // نمرر قيمة isAdmin لصفحة التنقل
        mainScreen: MainNavigation(isAdmin: isAdmin),
        angle: -10,
        borderRadius: 35,
        slideWidth: MediaQuery.of(context).size.width * 0.82,
        showShadow: true,
        drawerShadowsBackgroundColor: Colors.pink.shade100.withOpacity(0.15),
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 300),
        mainScreenTapClose: true,
      ),
    );
  }
}