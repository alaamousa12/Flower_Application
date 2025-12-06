import 'package:flutter/material.dart';
import '../orders/my_orders_screen.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  const PaymentSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تحديد لون الأيقونة والأزرار الرئيسي
    const Color primaryColor = Colors.pink; // لون أرجواني عميق

    return Scaffold(
      // شريط التطبيق (AppBar) مع زر العودة
      appBar: AppBar(
        // إزالة الظل أسفل شريط التطبيق
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
             Navigator.pop(context);
          },
        ),
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      // جسم الشاشة
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // لتركيز العناصر في منتصف الشاشة عمودياً
            mainAxisAlignment: MainAxisAlignment.center,
            // لتركيز العناصر في منتصف الشاشة أفقياً
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 1. أيقونة الدفع الناجح (الدائرة الأرجوانية والعلامة البيضاء)
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),

              // 2. عنوان "Payment Successful!"
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // 3. رسالة "Thank you for your purchase."
              const Text(
                'Thank you for your purchase.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              // لإنشاء مسافة كبيرة بين النصوص والأزرار
              const Spacer(),

              // 4. زر "View Order" (الزر الأرجواني الرئيسي)
              SizedBox(
                width: double.infinity, // لملء العرض
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersScreen(), // اسم الشاشة التي تريد الذهاب إليها
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Order',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 5. زر "View E-Receipt" (الرابط النصي)
              TextButton(
                onPressed: () {
                  // كود عرض الإيصال الإلكتروني
                },
                child: const Text(
                  'View E-Receipt',
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 40), // مسافة إضافية في الأسفل
            ],
          ),
        ),
      ),
    );
  }
}

