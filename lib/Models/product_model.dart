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