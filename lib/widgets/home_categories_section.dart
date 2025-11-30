import 'package:flutter/material.dart';

class HomeCategoriesSection extends StatefulWidget {
  const HomeCategoriesSection({super.key});

  @override
  State<HomeCategoriesSection> createState() => _HomeCategoriesSectionState();
}

class _HomeCategoriesSectionState extends State<HomeCategoriesSection> {
  int selectedIndex = 0;

  final categories = [
    {"label": "Flowers", "icon": Icons.local_florist},
    {"label": "Chocolates", "icon": Icons.cookie},
    {"label": "Gifts", "icon": Icons.card_giftcard},
    {"label": "Birthday", "icon": Icons.cake},
    {"label": "Wedding", "icon": Icons.favorite},
    {"label": "Baby", "icon": Icons.child_friendly},
    {"label": "Perfumes", "icon": Icons.spa},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "🏷️ Recommended for you",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(height: 4),

        SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = categories[index];
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.pink.withOpacity(0.18)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        item["icon"] as IconData,
                        color: isSelected ? Colors.pink : Colors.grey.shade700,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["label"] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? Colors.pink : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
