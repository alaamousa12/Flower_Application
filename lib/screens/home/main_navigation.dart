import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../cart/cart_page.dart';
import '../orders/my_orders_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';
import '../favorites/favorites_screen.dart';
import '../admin/add_product_screen.dart';

class MainNavigation extends StatefulWidget {
  final bool isAdmin;
  const MainNavigation({super.key, this.isAdmin = false});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // 1. تعريف القوائم داخل build لضمان التحديث
    List<Widget> pages = [
      const HomeScreen(),
      const FavoritesScreen(),
      const CartPage(),
      const MyOrdersScreen(),
      const UserProfileScreen(fromBottomNav: true),
    ];

    List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(icon: Icon(IconlyLight.home), activeIcon: Icon(IconlyBold.home), label: "Home"),
      const BottomNavigationBarItem(icon: Icon(IconlyLight.heart), activeIcon: Icon(IconlyBold.heart), label: "Favorites"),
      const BottomNavigationBarItem(icon: Icon(IconlyLight.buy), activeIcon: Icon(IconlyBold.buy), label: "Cart"),
      const BottomNavigationBarItem(icon: Icon(IconlyLight.bag_2), activeIcon: Icon(IconlyBold.bag_2), label: "Orders"),
      const BottomNavigationBarItem(icon: Icon(IconlyLight.profile), activeIcon: Icon(IconlyBold.profile), label: "Profile"),
    ];

    // 2. إذا كان أدمن، نضيف الصفحة والزر
    if (widget.isAdmin) {
      pages.insert(2, const AddProductScreen());
      navItems.insert(2, const BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline, size: 32, color: Colors.pink),
        activeIcon: Icon(Icons.add_circle, size: 32, color: Colors.pink),
        label: "Add",
      ));
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages, // نستخدم القائمة المحلية
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: navItems, // نستخدم القائمة المحلية
        ),
      ),
    );
  }
}