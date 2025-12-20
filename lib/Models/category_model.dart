class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      // هنا لازم الاسم يكون زي ما مكتوب في الباك إند بالظبط
      id: json['categoryId'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}