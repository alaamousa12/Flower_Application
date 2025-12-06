import 'package:flutter/material.dart';
import '../../widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        "image": "assets/flower1.jpg",
        "title": "Pink Rose Bouquet",
        "price": 29.99,
        "category": "Roses",
        "rating": 4.7,
        "delivery": "Express",
        "discount": true,
      },
      {
        "image": "assets/flower2.jpg",
        "title": "Fresh Tulips",
        "price": 19.99,
        "category": "Tulips",
        "rating": 4.3,
        "delivery": "Standard",
        "discount": false,
      },
      {
        "image": "assets/flower3.jpg",
        "title": "Luxury Flowers",
        "price": 39.99,
        "category": "Premium",
        "rating": 4.9,
        "delivery": "Express",
        "discount": true,
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 330,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, i) {
        final p = products[i];
        return ProductCard(
          image: p["image"] as String,
          title: p["title"] as String,
          price: p["price"] as double,
          category: p["category"] as String,
          rating: p["rating"] as double,
          // delivery: p["delivery"] as String,
          discount: p["discount"] as bool,
        );
      },
    );
  }
}
