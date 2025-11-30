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
    final saleProducts = getSaleProducts();

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- NEW MINIMAL HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    'SALE',
                    style: TextStyle(
                      fontSize: 36, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333), // Dark grey
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Don’t miss out! Get yours before they’re all gone!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // Small note with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'All prices shown are inclusive of the discount',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey[400],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.blueGrey[400]),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // GRID (Same clean card design from before)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: saleProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65, 
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
          // IMAGE (Clean, white background)
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white, 
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          
          // Title
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(height: 5),

          // PRICE ROW
          Row(
            children: [
              Text(
                '£${product.oldPrice!.toStringAsFixed(2)}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '£${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.blueGrey[800],
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