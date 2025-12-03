import 'package:flutter/material.dart';
import '../models/product.dart';
// REMOVED: import '../data/dummy_data.dart';
import '../repositories/product_repository.dart'; // NEW IMPORT
import '../pages/product_page.dart';

class ProductSearchDelegate extends SearchDelegate {
  final ProductRepository _repository = ProductRepository();
  
  // 1. "Clear" button on the right
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = ''; 
            showSuggestions(context); // Refresh view
          },
        ),
    ];
  }

  // 2. "Back" button on the left
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  // 3. Show Results when Enter is pressed
  @override
  Widget buildResults(BuildContext context) {
    return _buildFutureList(context);
  }

  // 4. Show Suggestions while typing
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildFutureList(context);
  }

  // Shared Helper to build the list asynchronously
  Widget _buildFutureList(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Search for products...'));
    }

    return FutureBuilder<List<Product>>(
      future: _repository.getAllProducts(), // Fetch real data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products available.'));
        }

        final allProducts = snapshot.data!;
        
        // Filter the list based on the search text
        final List<Product> results = allProducts.where((product) {
          return product.title.toLowerCase().contains(query.toLowerCase());
        }).toList();

        if (results.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final product = results[index];
            return ListTile(
              leading: Image.asset(
                product.image, 
                width: 50, 
                height: 50, 
                fit: BoxFit.cover,
                errorBuilder: (c,o,s) => const Icon(Icons.image),
              ),
              title: Text(product.title),
              subtitle: Text('£${product.price.toStringAsFixed(2)}'),
              onTap: () {
                // Close search and navigate to product via Deep Link
                close(context, null); 
                Navigator.pushNamed(context, '/product/${product.id}');
              },
            );
          },
        );
      },
    );
  }
}