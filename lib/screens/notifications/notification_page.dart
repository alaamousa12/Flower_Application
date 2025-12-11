import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: Row(
          children: [
            // زر الرجوع
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),

            const Spacer(),

            const Text(
              "Notification",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            // لضبط التمركز (مساحة مساوية لعرض زر الرجوع)
            const SizedBox(width: 48),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 16),

            Text(
              "لا يوجد إشعارات حالياً",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
