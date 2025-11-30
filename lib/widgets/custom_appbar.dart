import 'package:flutter/material.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      shadowColor: Colors.black.withOpacity(0.05),
      titleSpacing: 0,

      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Menu Icon
            _iconBox(icon: Icons.menu, onTap: () {}),

            const SizedBox(width: 14),

            // Title
            const Expanded(
              child: Center(
                child: Text(
                  "Flower Shop",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // Notification icon
            _iconBox(icon: Icons.notifications_none_rounded, onTap: () {}),

            const SizedBox(width: 10),

            // Cart icon
            _iconBox(icon: Icons.shopping_bag_outlined, onTap: () {}),
          ],
        ),
      ),
    );
  }

  // widget reusable
  Widget _iconBox({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 22, color: Colors.pink),
      ),
    );
  }
}
