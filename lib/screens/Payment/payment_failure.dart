import 'package:flutter/material.dart';

class PaymentFailureScreen extends StatelessWidget {
  const PaymentFailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تحديد لون الفشل الرئيسي (الأحمر/الوردي)
    const Color failureColor = Color(0xFFF06292); // لون وردي/أحمر فاتح مشابه للصورة

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
              // 1. أيقونة فشل الدفع (الدائرة الحمراء وعلامة X البيضاء)
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: failureColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close, // علامة X
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),

              // 2. عنوان "Payment Failure"
              const Text(
                'Payment Failure',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // 3. رسالة "Please, Try again in another time"
              const Text(
                'Please, Try again in another time',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              // لإضافة مسافة (Spacer) لدفع الزر نحو الأسفل، كما ظهر في الصورة التوضيحية
              const Spacer(),

              // 4. زر "View Order" (الزر الأحمر/الوردي الرئيسي)
              SizedBox(
                width: double.infinity, // لملء العرض
                child: ElevatedButton(
                  onPressed: () {
                    // كود عرض الطلب أو محاولة الدفع مرة أخرى
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: failureColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Payment Methods ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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

