class AdminOrderModel {
  final int id;
  final int userId;
  final String status;
  final double totalAmount;
  final DateTime orderDate;
  final int itemsCount;
  final String paymentMethod;

  AdminOrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    required this.itemsCount,
    required this.paymentMethod,
  });

  factory AdminOrderModel.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v) => (v is int) ? v : int.tryParse(v.toString()) ?? 0;
    double _toDouble(dynamic v) => (v is num) ? v.toDouble() : double.tryParse(v.toString()) ?? 0;

    return AdminOrderModel(
      id: _toInt(json['id'] ?? json['Id']),
      userId: _toInt(json['userId'] ?? json['UserId']),
      status: (json['status'] ?? json['Status'] ?? 'Pending').toString(),
      totalAmount: _toDouble(json['totalAmount'] ?? json['TotalAmount']),
      orderDate: DateTime.tryParse((json['orderDate'] ?? json['OrderDate']).toString()) ?? DateTime.now(),
      itemsCount: _toInt(json['itemsCount'] ?? json['ItemsCount']),
      paymentMethod: (json['paymentMethod'] ?? json['PaymentMethod'] ?? '').toString(),
    );
  }

  AdminOrderModel copyWith({String? status}) => AdminOrderModel(
    id: id,
    userId: userId,
    status: status ?? this.status,
    totalAmount: totalAmount,
    orderDate: orderDate,
    itemsCount: itemsCount,
    paymentMethod: paymentMethod,
  );
}
