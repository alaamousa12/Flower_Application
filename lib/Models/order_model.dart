class OrderModel {
  final int id;
  final double totalPrice;
  final String status;
  final String date;
  final int itemsCount; // عدد المنتجات

  OrderModel({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.date,
    required this.itemsCount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      // 👇 قراءة الـ id (سواء جاء بحرف كبير أو صغير)
      id: json['id'] ?? json['orderId'] ?? 0,

      // 👇 الباك إند يرسل 'totalAmount'، نستقبله هنا
      totalPrice: (json['totalAmount'] ?? json['totalPrice'] ?? 0).toDouble(),

      status: json['status'] ?? "Pending",

      // 👇 تنسيق التاريخ (نأخذ أول 10 حروف فقط لعرض اليوم والشهر والسنة)
      date: json['orderDate'] != null
          ? json['orderDate'].toString().substring(0, 10)
          : DateTime.now().toString().substring(0, 10),

      itemsCount: json['itemsCount'] ?? 0,
    );
  }
}