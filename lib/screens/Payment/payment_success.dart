import 'package:flutter/material.dart';
import '../orders/my_orders_screen.dart';
import '../home/main_navigation.dart'; // ✅ عدل المسار حسب عندك

class PaymentSuccessfulScreen extends StatelessWidget {
  final String paymentMethod; // "Cash" / "Card" / "Wallet"

  const PaymentSuccessfulScreen({
    super.key,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.pink; // للأزرار
    const Color successGreen = Color(0xFFA5D6A7); // ✅ أخضر فاتح للدائرة

    final bool isCash = paymentMethod.toLowerCase() == "cash";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // ✅ الدائرة الخضرا
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: successGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                isCash ? 'Order Placed Successfully!' : 'Payment Successful!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                isCash
                    ? 'You chose Cash payment.\nWe will contact you soon.'
                    : 'Thank you for your purchase.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isCash) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainNavigation(),
                        ),
                            (route) => false,
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyOrdersScreen(),
                        ),
                            (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isCash ? 'Back to Home' : 'View Order',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (!isCash)
                TextButton(
                  onPressed: () {
                    // TODO: View E-Receipt
                  },
                  child: const Text(
                    'View E-Receipt',
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
