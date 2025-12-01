import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/shop_viewmodel.dart';
import '../models/product.dart';
import 'product_page.dart';       
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../widgets/home_carousel.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ShopViewModel for data
    final shopVM = Provider.of<ShopViewModel>(context);
    final products = shopVM.products;

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeCarousel(),
            
            const SizedBox(height: 40),

            const Text('Essential Range', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 20),
            
            // Display products using ViewModel data
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: products.isEmpty 
                  ? [const Center(child: CircularProgressIndicator())]
                  : products.take(4).map((product) {
                    return _buildProductItem(context, product);
                  }).toList(),
            ),

            const SizedBox(height: 40),

            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  // A helper to build a clickable product card
  Widget _buildProductItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
      },
      child: Container(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            
            // Price Logic (handles sale)
            if (product.oldPrice != null)
              Row(
                children: [
                   Text('£${product.oldPrice!.toStringAsFixed(2)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 13)),
                   const SizedBox(width: 5),
                   Text('£${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              )
            else
              Text('£${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}