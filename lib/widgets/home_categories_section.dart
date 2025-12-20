import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../Models/category_model.dart';
import '../screens/products/category_products_screen.dart';

class HomeCategoriesSection extends StatefulWidget {
  const HomeCategoriesSection({super.key});

  @override
  State<HomeCategoriesSection> createState() => _HomeCategoriesSectionState();
}

class _HomeCategoriesSectionState extends State<HomeCategoriesSection> {
  int selectedIndex = 0;

  // ✅ IDs مؤقتة للقسمين الجداد
  // بعد ما تضيفهم في DB غيّر الأرقام دي بـ IDs الحقيقية
  static const int birthdayCategoryId = 1002;
  static const int luxuryCategoryId = 1003;

  // ✅ عنصرين إضافيين (Static)
  final List<CategoryModel> _extraCategories = [
    CategoryModel(id: birthdayCategoryId, name: "Birthday Flowers 🎂"),
    CategoryModel(id: luxuryCategoryId, name: "Luxury Bouquets 💎"),
  ];

  IconData _getIconForCategory(String name) {
    final n = name.toLowerCase();

    if (n.contains("flower") || n.contains("rose")) return Icons.local_florist;
    if (n.contains("chocolate") || n.contains("cookie")) return Icons.cookie;
    if (n.contains("gift")) return Icons.card_giftcard;
    if (n.contains("birthday")) return Icons.cake;
    if (n.contains("luxury") || n.contains("diamond")) return Icons.diamond;
    if (n.contains("wedding") || n.contains("love")) return Icons.favorite;
    if (n.contains("baby")) return Icons.child_friendly;
    if (n.contains("perfume")) return Icons.spa;

    return Icons.category;
  }

  void _goToCategory(CategoryModel category, int index) {
    setState(() => selectedIndex = index);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProductsScreen(
          categoryId: category.id,
          categoryName: category.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "🏷️ Recommended for you",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20, color: Colors.grey),
                onPressed: () => setState(() {}),
              )
            ],
          ),
        ),

        const SizedBox(height: 4),

        SizedBox(
          height: 98, // ✅ زودناها شوية عشان الاسم الطويل (Luxury...) يبقى لطيف
          child: FutureBuilder<List<CategoryModel>>(
            future: ApiService().getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Error loading categories",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final apiCategories = snapshot.data ?? [];

              // ✅ دمج: Categories من API + 2 Categories ثابتين
              final categories = <CategoryModel>[
                ...apiCategories,
                ..._extraCategories,
              ];

              if (categories.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("No categories found", style: TextStyle(color: Colors.grey)),
                );
              }

              // ✅ لو selectedIndex أكبر من الليست (بعد refresh) نرجعه 0
              if (selectedIndex >= categories.length) {
                selectedIndex = 0;
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedIndex == index;

                  // ✅ شكل خاص للقسمين الجداد
                  final isExtra = index >= apiCategories.length;

                  return GestureDetector(
                    onTap: () => _goToCategory(category, index),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isExtra ? Colors.amber.withOpacity(0.18) : Colors.pink.withOpacity(0.18))
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: (isExtra ? Colors.amber : Colors.pink).withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                                : [],
                          ),
                          child: Icon(
                            _getIconForCategory(category.name),
                            color: isSelected
                                ? (isExtra ? Colors.amber.shade800 : Colors.pink)
                                : Colors.grey.shade700,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 78, // ✅ عشان Birthday / Luxury تبان مرتبة
                          child: Text(
                            category.name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected
                                  ? (isExtra ? Colors.amber.shade800 : Colors.pink)
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
