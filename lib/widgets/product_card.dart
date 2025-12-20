import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../Models/product_model.dart';
import '../Managers/favourite_manager.dart';
import '../Managers/cart_manager.dart'; // استدعاء مدير السلة

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // استدعاء المديرين
    final favoritesManager = Provider.of<FavoritesManager>(context);
    final cartManager = Provider.of<CartManager>(context);

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج + زر القلب
            Stack(
              children: [
                Hero(
                  tag: product.id.toString(),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                    child: Image.network(
                      product.image,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        height: 170,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      // 👇👇 تفعيل زر المفضلة 👇👇
                      favoritesManager.toggleFavorite(product);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: Icon(
                        favoritesManager.isFavorite(product) ? IconlyBold.heart : IconlyLight.heart,
                        color: favoritesManager.isFavorite(product) ? Colors.pink : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // التفاصيل + زر الإضافة للسلة
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink, fontSize: 16),
                      ),

                      // 👇👇 تفعيل زر السلة (Buy/Add) 👇👇
                      GestureDetector(
                        onTap: () {
                          cartManager.addToCart(product);
                          // إظهار رسالة تأكيد صغيرة
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Added to Cart!"),
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.pink,
                          child: Icon(IconlyBold.buy, color: Colors.white, size: 16),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}