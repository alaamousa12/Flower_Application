import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:quiz_app/screens/home/home_screen.dart';
import 'package:quiz_app/widgets/app_drawer.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: ZoomDrawer(
        menuScreen: const AppDrawer(),
        mainScreen: const HomeScreen(),

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
