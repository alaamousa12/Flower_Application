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
