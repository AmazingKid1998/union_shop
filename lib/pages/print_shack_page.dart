import 'package:flutter/material.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';
import '../models/product.dart';
import '../models/cart.dart'; // Import the global cart
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
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Personalised Hoodie', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            
            // 1. Static Product Image
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                'https://via.placeholder.com/400x400/4B0082/ffffff?text=Your+Text+Here', 
                fit: BoxFit.cover
              ),
            ),

            const SizedBox(height: 20),

            // 2. The Form Area
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price: £35.00', style: TextStyle(fontSize: 22, color: Colors.indigo, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('Enter the name or text you want printed on the back:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  
                  // The Input Box
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Personalisation Text',
                      hintText: 'e.g. SOFTWARE ENG 25',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo, 
                        padding: const EdgeInsets.symmetric(vertical: 15)
                      ),
                      onPressed: () {
                         // Validation: Make sure they typed something
                         if (_textController.text.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Please enter text for personalisation'))
                           );
                           return;
                         }

                         // 1. Create a dynamic product object with their text
                         final customProduct = Product(
                           id: 'custom_${DateTime.now().millisecondsSinceEpoch}', // Unique ID
                           title: 'Personalised Hoodie',
                           price: 35.00,
                           image: 'https://via.placeholder.com/150/4B0082/ffffff?text=Custom',
                           // We save their custom text in the description so it shows up in the cart!
                           description: 'Custom Print: "${_textController.text}"',
                         );

                         // 2. Add to global cart
                         globalCart.add(customProduct);

                         // 3. Navigate to Cart immediately
                         Navigator.push(
                           context, 
                           MaterialPageRoute(builder: (context) => const CartPage())
                         ).then((_) => (context as Element).markNeedsBuild());
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
}