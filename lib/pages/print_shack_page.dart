import 'package:flutter/material.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../models/product.dart';
import '../models/cart.dart';
import 'cart_page.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Breadcrumb (Mimicking the real site)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text('Home / Personalise Text', style: TextStyle(color: Colors.grey)),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image (Mimics the "P" image on the site)
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.black,
                        child: const Text(
                          "P", 
                          style: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 2. Product Details
                  const Text('Personalise Text', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Georgia')),
                  const SizedBox(height: 10),
                  const Text('£3.00', style: TextStyle(fontSize: 24, color: Colors.grey)),
                  
                  const SizedBox(height: 30),

                  // 3. The Input Form
                  const Text('Text', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 4. Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)) // Boxy button like real site
                      ),
                      onPressed: () {
                         if (_textController.text.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter text')));
                           return;
                         }

                         // Add to global cart
                         final customProduct = Product(
                           id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                           title: 'Personalise Text',
                           price: 3.00,
                           image: 'https://via.placeholder.com/150/000000/FFFFFF/?text=P',
                           // Format exactly how we want it in the cart
                           description: 'Text: ${_textController.text}', 
                         );

                         globalCart.add(customProduct);

                         // Navigate to Cart
                         Navigator.push(
                           context, 
                           MaterialPageRoute(builder: (context) => const CartPage())
                         ).then((_) => (context as Element).markNeedsBuild());
                      },
                      child: const Text('ADD TO CART', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
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
}