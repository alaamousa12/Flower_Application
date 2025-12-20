import 'package:flutter/material.dart';
import '../Models/product_model.dart';

class FavoritesManager extends ChangeNotifier {
  // القائمة التي تحمل المنتجات المفضلة محلياً
  final List<ProductModel> _favorites = [];

  // لاسترجاع القائمة في الشاشات
  List<ProductModel> get favorites => _favorites;

  // دالة الإضافة والحذف (التي يستدعيها زر القلب)
  void toggleFavorite(ProductModel product) {
    final isExist = _favorites.any((element) => element.id == product.id);

    if (isExist) {
      _favorites.removeWhere((element) => element.id == product.id);
    } else {
      _favorites.add(product);
    }
    // 👇 هذا السطر هو الأهم! هو الذي يخبر صفحة المفضلة أن البيانات تغيرت
    notifyListeners();
  }

  // للتحقق هل المنتج مفضل أم لا (لتلوين القلب بالأحمر)
  bool isFavorite(ProductModel product) {
    return _favorites.any((element) => element.id == product.id);
  }
}