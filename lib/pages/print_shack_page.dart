import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/product.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final String _productImage = 'assets/images/print_preview.jpg';

  final Map<String, double> _pricingMap = {
    'One Line of Text': 3.00,
    'Two Lines of Text': 5.00,
    'Three Lines of Text': 7.50,
    'Four Lines of Text': 10.00,
    'Small Logo (Chest)': 3.00,
    'Large Logo (Back)': 6.00,
  };

  late String _selectedOption;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedOption = _pricingMap.keys.first;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  int get _linesToDisplay {
    if (_selectedOption == 'Two Lines of Text') return 2;
    if (_selectedOption == 'Three Lines of Text') return 3;
    if (_selectedOption == 'Four Lines of Text') return 4;
    return 1;
  }

  double get _currentPrice => _pricingMap[_selectedOption]!;

  @override
  Widget build(BuildContext context) {
    final cartVM = Provider.of<CartViewModel>(context, listen: false);

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Breadcrumb
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
                  // IMAGE
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]!)
                    ),
                    child: Image.asset(
                      _productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Center(
                        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // TITLE & PRICE
                  const Text('Personalisation', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Georgia', color: Color(0xFF333333))),
                  const SizedBox(height: 10),
                  
                  Text('£${_currentPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, color: Colors.blueGrey[700], fontWeight: FontWeight.bold)),
                  const Text('Tax included.', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  
                  const SizedBox(height: 30),

                  // DROPDOWN
                  const Text('Per Line: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54), 
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedOption,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: _pricingMap.keys.map((String option) {
                          return DropdownMenuItem<String>(value: option, child: Text(option));
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedOption = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DYNAMIC TEXT FIELDS
                  ...List.generate(_linesToDisplay, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Personalisation Line ${index + 1}:', style: const TextStyle(color: Colors.grey, fontSize: 16)),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _controllers[index],
                          decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  }),

                  const SizedBox(height: 5),

                  // QUANTITY INPUT
                  const Text('Quantity', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(vertical: 10)),
                      controller: TextEditingController(text: '$_quantity'),
                      onChanged: (value) {
                        _quantity = int.tryParse(value) ?? 1;
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ADD TO CART BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF4B0082), width: 1.5), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                      onPressed: () {
                         List<String> collectedText = [];
                         for (int i = 0; i < _linesToDisplay; i++) {
                           if (_controllers[i].text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter text for Line ${i+1}')));
                              return;
                           }
                           collectedText.add(_controllers[i].text);
                         }

                         String finalDescription = "$_selectedOption: ${collectedText.join(' / ')}";

                         for (int i = 0; i < _quantity; i++) {
                           final customProduct = Product(
                             id: 'custom_${DateTime.now().millisecondsSinceEpoch}_$i',
                             title: 'Personalisation',
                             price: _currentPrice,
                             image: _productImage,
                             description: finalDescription, 
                             collectionIds: ['custom'], // UPDATED: Pass list
                           );
                           cartVM.add(customProduct); 
                         }

                         // NAV CHANGE: Use Named Route for Cart
                         Navigator.pushNamed(context, '/cart').then((_) => setState(() {}));
                      },
                      child: const Text('ADD TO CART', style: TextStyle(color: Color(0xFF4B0082), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
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