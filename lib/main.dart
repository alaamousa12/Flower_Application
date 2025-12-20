import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Managers/cart_manager.dart';
import 'Managers/favourite_manager.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/home/main_navigation.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. قراءة البيانات المحفوظة
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  final int? userId = prefs.getInt('userId');
  final String? userEmail = prefs.getString('userEmail'); // نحتاج الإيميل للتحقق

  // 2. تحديد الشاشة التي سيبدأ منها التطبيق
  Widget startScreen;

  if (userId != null) {
    // المستخدم مسجل دخول -> نتحقق هل هو أدمن؟
    bool isAdmin = userEmail?.toLowerCase() == "admin@flower.com";
    startScreen = MainNavigation(isAdmin: isAdmin); // 👈 نمرر الصلاحية هنا
  } else if (seenOnboarding) {
    startScreen = const SigninScreen();
  } else {
    startScreen = const OnboardingScreen();
  }

  runApp(MyApp(startScreen: startScreen));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartManager()),
        ChangeNotifierProvider(create: (context) => FavoritesManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flower Shop',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: startScreen, // الشاشة التي حددناها بالأعلى
      ),
    );
  }
}