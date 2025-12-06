import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/product_card.dart';
import '../../Managers/favourite_manager.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesManager = Provider.of<FavoritesManager>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("My Favorites", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: favoritesManager.favorites.isEmpty
          ? const Center(child: Text("No favorites yet!", style: TextStyle(fontSize: 16)))
          : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: favoritesManager.favorites.length,
        itemBuilder: (context, index) {
          final product = favoritesManager.favorites[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}
