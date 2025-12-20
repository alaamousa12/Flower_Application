import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconly/iconly.dart';
import '../../Managers/favourite_manager.dart';
import '../../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 👇👇 الاستماع لمدير المفضلة لعرض البيانات لحظياً 👇👇
    final favoritesManager = Provider.of<FavoritesManager>(context);
    final favorites = favoritesManager.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites (${favorites.length})",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        // زر الرجوع
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconlyLight.heart, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            const Text("No Favorites Yet", style: TextStyle(color: Colors.grey, fontSize: 18)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          // نعرض المنتج
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProductCard(product: favorites[index]),
          );
        },
      ),
    );
  }
}