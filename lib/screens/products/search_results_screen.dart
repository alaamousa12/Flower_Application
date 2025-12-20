import 'package:flutter/material.dart';
import '../../Models/product_model.dart';
import '../../services/api_service.dart';
import 'product_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "$searchQuery"'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: ApiService().searchProducts(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (_, i) {
              final p = products[i];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(
                        image: p.image,
                        title: p.title,
                        price: p.price,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(p.image, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 6),
                    Text(p.title, maxLines: 1),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
