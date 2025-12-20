import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../services/api_service.dart';
import '../screens/notifications/notification_page.dart'; // عدّل المسار لو مختلف

class CustomHomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  State<CustomHomeAppBar> createState() => _CustomHomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomHomeAppBarState extends State<CustomHomeAppBar> {
  int _unreadCount = 0;
  bool _loadingCount = true;

  @override
  void initState() {
    super.initState();
    _refreshUnreadCount();
  }

  Future<void> _refreshUnreadCount() async {
    setState(() => _loadingCount = true);
    final count = await ApiService().getUnreadNotificationCount();
    if (!mounted) return;
    setState(() {
      _unreadCount = count;
      _loadingCount = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,

      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(IconlyLight.category, color: Colors.black),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),

      title: Text(
        "Flower Shop",
        style: TextStyle(
          color: Colors.grey.shade900,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),

      actions: [
        IconButton(
          onPressed: () async {
            final changed = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationPage()),
            );

            // ✅ لو حصل تغيير أو حتى لا، نحدّث العداد
            if (changed == true) {
              await _refreshUnreadCount();
            } else {
              await _refreshUnreadCount();
            }
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(IconlyLight.notification, color: Colors.black),

              if (!_loadingCount && _unreadCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    constraints:
                    const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Center(
                      child: Text(
                        _unreadCount > 99 ? "99+" : _unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}
