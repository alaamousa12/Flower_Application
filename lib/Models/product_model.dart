<<<<<<< HEAD
class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  // دالة بتحول الـ JSON اللي جاي من السيرفر لـ منتج فلاتر يفهمه
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // ركز هنا: الأسماء دي لازم تكون زي اللي بتظهرلك في Swagger بالظبط
      id: json['productId'] ?? 0,
      name: json['name'] ?? 'No Name',
      // السطر ده عشان لو السعر جه رقم صحيح يحوله لعشري من غير مشاكل
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['mainImageUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
=======
class ProductModel {
  final String image;
  final String title;
  final double price;
  final String category;
  final double rating;
  final bool discount;

  ProductModel({
    required this.image,
    required this.title,
    required this.price,
    required this.category,
    required this.rating,
    this.discount = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductModel &&
              runtimeType == other.runtimeType &&
              image == other.image &&
              title == other.title;

  @override
  int get hashCode => image.hashCode ^ title.hashCode;
}
>>>>>>> f3e54aa79b43e943732c71c9fba599bf6fb19efb
