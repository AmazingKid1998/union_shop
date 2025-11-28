import 'package:flutter/material.dart';
import '../models/cart.dart'; // Import the global list
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Your Basket', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),

          // The List
          Expanded(
            child: globalCart.isEmpty
                ? const Center(child: Text('Your basket is empty.'))
                : ListView.builder(
                    itemCount: globalCart.length,
                    itemBuilder: (context, index) {
                      final product = globalCart[index];
                      // Check if this is a custom item to show the text
                      final isCustom = product.id.startsWith('custom_');

                      return Column(
                        children: [
                          ListTile(
                            leading: Image.network(product.image, width: 60, height: 60, fit: BoxFit.cover),
                            title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text('£${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.indigo)),
                                
                                // THIS IS THE FIX: Show the custom text if it exists
                                if (isCustom) 
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      product.description, // This contains "Text: Your Name"
                                      style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                                    ),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  globalCart.remove(product);
                                });
                              },
                            ),
                          ),
                          const Divider(), // Adds a line between items like the real site
                        ],
                      );
                    },
                  ),
          ),

          // Total & Checkout
          if (globalCart.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[50], // Slightly off-white background
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(fontSize: 18)),
                      Text('£${getCartTotal().toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Shipping, taxes, and discounts codes calculated at checkout.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo, 
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                      ),
                      onPressed: () {
                        setState(() {
                           globalCart.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Placed!')));
                      },
                      child: const Text('Check out', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}