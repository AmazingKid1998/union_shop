import 'package:flutter/material.dart';
import '../models/cart.dart'; // Import the global list
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

// NOTE: We change 'StatelessWidget' to 'StatefulWidget' so we can update the screen when deleting items
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
                      return ListTile(
                        leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(product.title),
                        subtitle: Text('£${product.price}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              globalCart.remove(product); // Remove and refresh screen
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),

          // Total & Checkout
          if (globalCart.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('£${getCartTotal().toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, padding: const EdgeInsets.symmetric(vertical: 15)),
                      onPressed: () {
                        setState(() {
                           globalCart.clear(); // Clear list
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Placed!')));
                      },
                      child: const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 18)),
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