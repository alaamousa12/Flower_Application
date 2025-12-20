import 'package:flutter/material.dart';
import '../../Models/order_model.dart';
import '../../services/api_service.dart';
// 👇 مهم جداً: استيراد ملف الصفحة الرئيسية للعودة إليها عند الحاجة
import '../home/main_navigation.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<OrderModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final fetchedOrders = await ApiService().getOrders();
    if (mounted) {
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,

        // 👇👇 هنا تمت إضافة زر الرجوع 👇👇
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // 1. نحاول الرجوع للخلف خطوة (Pop)
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            // 2. إذا لم يكن هناك خلف (مثلاً بعد الشراء)، نذهب للرئيسية
            else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => const MainNavigation()),
              );
            }
          },
        ),
        // 👆👆 ----------------------- 👆👆
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text("No Orders Yet", style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // رقم الطلب والحالة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order #${order.id}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: order.status == "Pending" ? Colors.orange.shade100 : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            color: order.status == "Pending" ? Colors.orange.shade800 : Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // التفاصيل: التاريخ وعدد العناصر
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(order.date, style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      const Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("${order.itemsCount} Items", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // السعر الإجمالي
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount:", style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        "\$${order.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}