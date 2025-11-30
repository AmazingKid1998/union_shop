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

          // THE CART LIST
          Expanded(
            child: globalCart.isEmpty
                ? const Center(child: Text('Your basket is empty.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: globalCart.length,
                    separatorBuilder: (c, i) => const Divider(height: 40),
                    itemBuilder: (context, index) {
                      final product = globalCart[index];
                      // Check if this is a custom item
                      final isCustom = product.id.startsWith('custom_');

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. PRODUCT IMAGE
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Image.asset(
                              product.image, 
                              fit: BoxFit.cover,
                              errorBuilder: (c,o,s) => const Icon(Icons.image_not_supported),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // 2. PRODUCT DETAILS (Middle Column)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title, 
                                  style: TextStyle(
                                    fontSize: 16, 
                                    color: Colors.blue[900], // Match screenshot blue title
                                    fontWeight: FontWeight.w500
                                  )
                                ),
                                const SizedBox(height: 8),

                                // CUSTOM PARSING LOGIC
                                if (isCustom) 
                                  _buildCustomDetails(product.description),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          // 3. PRICE & EDIT (Right Column)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '£${product.price.toStringAsFixed(2)}', 
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                              ),
                              const SizedBox(height: 10),
                              
                              // EDIT BUTTON
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                  side: const BorderSide(color: Colors.indigo),
                                  minimumSize: const Size(0, 30), // Compact button
                                ),
                                onPressed: () {
                                  // Visual placeholder for Edit functionality
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature coming soon!')));
                                },
                                child: const Text('EDIT', style: TextStyle(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.bold)),
                              ),

                              // Remove Button (Small icon below)
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                onPressed: () {
                                  setState(() {
                                    globalCart.removeAt(index);
                                  });
                                },
                              )
                            ],
                          )
                        ],
                      );
                    },
                  ),
          ),

          // FOOTER / CHECKOUT SECTION
          if (globalCart.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[50], 
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

  // --- HELPER TO PARSE AND FORMAT THE TEXT ---
  Widget _buildCustomDetails(String description) {
    // Expected format: "Two Lines of Text: Hello / World"
    if (!description.contains(':')) return Text(description);

    try {
      final int splitIndex = description.indexOf(':');
      final String optionName = description.substring(0, splitIndex); // "Two Lines of Text"
      final String content = description.substring(splitIndex + 1).trim(); // "Hello / World"
      
      // Split the content by the separator we used (" / ")
      final List<String> lines = content.split(' / ');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Per Line: Two Lines of Text"
          Text(
            'Per Line: $optionName', 
            style: TextStyle(color: Colors.blueGrey[700], fontSize: 13, fontStyle: FontStyle.italic)
          ),
          
          const SizedBox(height: 8),

          // Loop through each line to display exactly like screenshot
          ...List.generate(lines.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personalisation', 
                    style: TextStyle(color: Colors.blue[800], fontSize: 13) // Blue header
                  ),
                  Text(
                    'Line ${index + 1}: ${lines[index]}',
                    style: TextStyle(color: Colors.blueGrey[600], fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    } catch (e) {
      // Fallback if parsing fails
      return Text(description, style: const TextStyle(color: Colors.grey));
    }
  }
}