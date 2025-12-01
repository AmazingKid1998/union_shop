import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/product.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({super.key, required this.product});
  
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // Local state for quantity selector (optional feature)
  int _quantity = 1; 

  @override
  Widget build(BuildContext context) {
    // Access the Cart ViewModel (for Add to Cart functionality)
    final cartVM = Provider.of<CartViewModel>(context, listen: false);
    final product = widget.product;
    
    // Check if on sale
    final bool isOnSale = product.oldPrice != null;

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[100],
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
            
            const SizedBox(height: 20),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  
                  // Price Logic (Handles Sale Display)
                  if (isOnSale)
                    Row(
                      children: [
                        Text(
                          '£${product.oldPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '£${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  else
                    Text(
                      '£${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 22, color: Colors.indigo),
                    ),
                    
                  const SizedBox(height: 20),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  
                  // Quantity Selector (Simple implementation)
                  const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(context, Icons.remove, () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      }),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(_quantity.toString(), style: const TextStyle(fontSize: 18)),
                      ),
                      _buildQuantityButton(context, Icons.add, () {
                        setState(() {
                          _quantity++;
                        });
                      }),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Add to Cart Button (Uses ViewModel Action)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                         // Add item(s) using the ViewModel
                         for (int i = 0; i < _quantity; i++) {
                           cartVM.add(product);
                         }
                         
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('${product.title} added (x$_quantity)!'))
                         );
                         
                         // Automatically navigate to cart, forcing visual update
                         Navigator.pushNamed(context, '/cart');
                      },
                      child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      ),
    );
  }
}