import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/home_categories_section.dart';
import 'package:quiz_app/widgets/products_grid.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/home_search_bar.dart';
import '../../widgets/special_offers_section.dart';
// 👇 1. استدعاء ملف الدرور (تأكد من المسار الصحيح حسب مشروعك)
import '../../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👇 2. هذا هو السطر الناقص الذي يسبب المشكلة
      drawer: const AppDrawer(),

      appBar: const CustomHomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HomeSearchBar(),
            SpecialOffersSection(),
            SizedBox(height: 8),
            HomeCategoriesSection(),
            SizedBox(height: 16),
            ProductsGrid(),
          ],
        ),
      ),
    );
  }
}