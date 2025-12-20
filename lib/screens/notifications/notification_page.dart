import 'package:flutter/material.dart';
import '../../Models/notification_model.dart';
import '../../services/api_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> _items = [];
  bool _loading = true;

  bool _changed = false; // ✅ لو حصل أي mark-read

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await ApiService().getNotifications();
    if (!mounted) return;
    setState(() {
      _items = data;
      _loading = false;
    });
  }

  Future<void> _markRead(NotificationModel n) async {
    if (n.isRead) return;

    _changed = true;

    // Optimistic update
    setState(() {
      _items = _items
          .map((e) => e.id == n.id ? e.copyWith(isRead: true) : e)
          .toList();
    });

    final ok = await ApiService().markNotificationAsRead(n.id);
    if (!ok && mounted) {
      // رجّعها unread لو فشل
      setState(() {
        _items = _items
            .map((e) => e.id == n.id ? e.copyWith(isRead: false) : e)
            .toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to mark as read"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _items.where((e) => !e.isRead).length;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _changed); // ✅ رجّع هل حصل تغيير
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:
          const Text("Notifications", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications, color: Colors.black),
                  if (unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          unreadCount > 99 ? "99+" : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _load,
          child: _items.isEmpty
              ?  ListView(
            children: const [
              SizedBox(height: 200),
              Center(child: Text("No notifications yet")),
            ],
          )
              : ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = _items[index];

              return ListTile(
                onTap: () => _markRead(n),
                leading: CircleAvatar(
                  backgroundColor: n.isRead
                      ? Colors.grey.shade200
                      : Colors.pink.shade100,
                  child: Icon(
                    Icons.notifications,
                    color: n.isRead ? Colors.grey : Colors.pink,
                  ),
                ),
                title: Text(
                  n.title,
                  style: TextStyle(
                    fontWeight: n.isRead
                        ? FontWeight.w500
                        : FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  n.message,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                trailing: n.isRead
                    ? const Icon(Icons.check,
                    color: Colors.green, size: 18)
                    : Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
