import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:quiz_app/screens/cart/your_cart.dart';
import 'package:quiz_app/screens/orders/my_orders_screen.dart';
import 'package:quiz_app/screens/profile/profile_screen.dart';
import '../home/home_screen.dart';
import '../favorites/favorites_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [const HomeScreen(), const FavoritesScreen(), const YourCart()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) async {
            if (index == 4) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserProfileScreen(fromBottomNav: true),
                ),
              );

              if (!mounted) return;
              setState(() {
                _currentIndex = 0;
                _pageController.jumpToPage(0);
              });
              return;
            }

            if (index == 3) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
              );

              if (!mounted) return;
              setState(() {
                _currentIndex = 0;
                _pageController.jumpToPage(0);
              });
              return;
            }

            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },

          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey.shade500,
          showSelectedLabels: true,
          showUnselectedLabels: true,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.home),
              activeIcon: Icon(IconlyBold.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.heart),
              activeIcon: Icon(IconlyBold.heart),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.buy),
              activeIcon: Icon(IconlyBold.buy),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.bag_2),
              activeIcon: Icon(IconlyBold.bag_2),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.profile),
              activeIcon: Icon(IconlyBold.profile),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
