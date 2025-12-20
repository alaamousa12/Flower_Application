import 'package:flutter/material.dart';
import '../Models/product_model.dart';

class CartManager extends ChangeNotifier {
  final List<ProductModel> _cartItems = [];

  List<ProductModel> get cartItems => _cartItems;

  // إضافة منتج للسلة
  void addToCart(ProductModel product) {
    // التحقق لمنع التكرار (اختياري، يمكنك حذفه لو تريد تكرار المنتج)
    // if (!_cartItems.any((item) => item.id == product.id)) {
    _cartItems.add(product);
    notifyListeners();
    // }
  }

  // حذف منتج من السلة
  void removeFromCart(ProductModel product) {
    _cartItems.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  // 👇👇 دالة تفريغ السلة (هذه هي الدالة الناقصة) 👇👇
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
  // 👆👆

  // حساب المجموع الكلي
  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.price;
    }
    return total;
  }
}