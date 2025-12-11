import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/splash/splash_screen.dart';
import 'package:quiz_app/Managers/favourite_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesManager(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
