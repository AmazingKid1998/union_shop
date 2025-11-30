import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/product.dart';
import 'product_page.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class SalePage extends StatelessWidget {
  const SalePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get sale items
    final saleProducts = getSaleProducts();

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: Colors.redAccent,
              padding: const EdgeInsets.all(30),
              child: const Column(
                children: [
                  Text('FLASH SALE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  SizedBox(height: 10),
                  Text('Limited time offers!', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: saleProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65, // Taller to fit the text
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 30,
                ),
                itemBuilder: (context, index) {
                  return _buildSaleCard(context, saleProducts[index]);
                },
              ),
            ),
            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ProductPage(product: product)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE (Clean, no stamp)
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white, // Clean white background like the pic
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          
          // Title (Blue/Grey Bold)
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueGrey[800], // Matches the "Classic Sweatshirts" text color
            ),
          ),
          const SizedBox(height: 5),

          // PRICE ROW (The specific design you asked for)
          Row(
            children: [
              // 1. Old Price (Crossed out)
              Text(
                '£${product.oldPrice!.toStringAsFixed(2)}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2, // Thicker line matches the pic
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              
              // 2. New Price (Bold)
              Text(
                '£${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.blueGrey[800], // Matches title color
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}