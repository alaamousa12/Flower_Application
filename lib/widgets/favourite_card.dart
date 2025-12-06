import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconly/iconly.dart';

class FavoriteProductCard extends StatefulWidget {
  final String image;
  final String title;
  final double price;
  final String description;
  final double rating;
  final bool isInitiallyFavorite;

  const FavoriteProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.rating,
    this.isInitiallyFavorite = true,
  });

  @override
  State<FavoriteProductCard> createState() => _FavoriteProductCardState();
}

class _FavoriteProductCardState extends State<FavoriteProductCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isInitiallyFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 450),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // --- الصورة مع الهيرو 👇 ---
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(22)),
              child: Hero(
                tag: widget.image,
                child: Image.network(
                  widget.image,
                  height: 140,
                  width: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    width: 140,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------- العنوان ----------
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // -------- السعر ----------
                    Text(
                      "${widget.price.toStringAsFixed(2)} SAR",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // -------- الوصف ----------
                    Text(
                      widget.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // -------- AVALIABLE ----------
                    Row(
                      children: [
                        Icon(Icons.star, size: 15, color: Colors.amber.shade600),
                        const SizedBox(width: 3),
                        Text(
                          widget.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // -------- أيقونات (قلب + سلة) ----------
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? IconlyBold.heart : IconlyLight.heart,
                        color: isFavorite ? Colors.pink : Colors.grey,
                        size: 22,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      IconlyBold.buy,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
