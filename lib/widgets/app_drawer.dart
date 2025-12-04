import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade300, Colors.pink.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/user.png"), // Placeholder
              ),
              accountName: Text(
                "User Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                "user@gmail.com",
                style: TextStyle(color: Colors.white70),
              ),
            ),

            drawerItem(icon: Icons.person, text: "Profile", onTap: () {}),
            drawerItem(
              icon: Icons.location_on,
              text: "Delivery Address",
              onTap: () {},
            ),
            drawerItem(
              icon: Icons.favorite,
              text: "My Favorites",
              onTap: () {},
            ),
            drawerItem(
              icon: Icons.shopping_bag,
              text: "My Orders",
              onTap: () {},
            ),
            drawerItem(
              icon: Icons.notifications,
              text: "Notifications",
              onTap: () {},
            ),
            // const Divider(thickness: 1, height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // تقلل المسافة من الجوانب
              child: const Divider(
                thickness: 1,
                height: 20,
                color: Color.fromARGB(
                  255,
                  212,
                  209,
                  209,
                ), // اختياري لتغيير اللون
              ),
            ),

            drawerItem(
              icon: Icons.payment,
              text: "Payment Methods",
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // تقلل المسافة من الجوانب
              child: const Divider(
                thickness: 1,
                height: 20,
                color: Color.fromARGB(
                  255,
                  212,
                  209,
                  209,
                ), // اختياري لتغيير اللون
              ),
            ),

            drawerItem(
              icon: Icons.help_center,
              text: "Help Center",
              onTap: () {},
            ),
            drawerItem(icon: Icons.settings, text: "Settings", onTap: () {}),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // تقلل المسافة من الجوانب
              child: const Divider(
                thickness: 1,
                height: 20,
                color: Color.fromARGB(
                  255,
                  212,
                  209,
                  209,
                ), // اختياري لتغيير اللون
              ),
            ),

            // Logout
            drawerItem(icon: Icons.logout, text: "Logout", onTap: () {}),
          ],
        ),
      ),
    );
  }

  ListTile drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.pink),
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      horizontalTitleGap: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.pink.shade50, // للتأثير عند الضغط (desktop/web)
    );
  }
}
