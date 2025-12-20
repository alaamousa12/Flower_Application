class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final double rating;

  // ✅ Special Offer fields (من الباك اند)
  final bool isSpecialOffer;
  final double discountPercent;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    this.rating = 4.5,

    // ✅ defaults
    this.isSpecialOffer = false,
    this.discountPercent = 0,
  });

  // -------------------- helpers --------------------
  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  static bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    final s = v.toString().toLowerCase().trim();
    return s == "true" || s == "1" || s == "yes";
  }

  // ✅ السعر بعد الخصم
  double get discountedPrice {
    if (!isSpecialOffer || discountPercent <= 0) return price;
    return price * (1 - (discountPercent / 100));
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImage = (json['mainImageUrl'] ?? '').toString();

    return ProductModel(
      id: _toInt(json['productId'] ?? json['ProductId']),
      title: (json['name'] ?? json['Name'] ?? 'No Name').toString(),
      price: _toDouble(json['price'] ?? json['Price']),
      image: rawImage.replaceAll('localhost', '10.0.2.2'),
      description: (json['description'] ?? json['Description'] ?? '').toString(),
      category: (json['category'] != null && json['category'] is Map)
          ? (json['category']['name'] ?? 'General').toString()
          : (json['categoryName'] ?? json['CategoryName'] ?? 'General').toString(),
      rating: 4.5,

      // ✅ Special Offer mapping (لو موجود في الباك اند)
      isSpecialOffer: _toBool(json['isSpecialOffer'] ?? json['IsSpecialOffer']),
      discountPercent: _toDouble(json['discountPercent'] ?? json['DiscountPercent']),
    );
  }
}
