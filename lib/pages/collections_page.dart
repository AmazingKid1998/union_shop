import 'package:flutter/material.dart';
import 'collection_detail_page.dart'; 
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Shop by Category', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // 2 items per row
                childAspectRatio: 0.8, // Taller cards to fit text
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  _buildCategoryCard(context, 'Clothing', 'c_clothing', 'assets/images/clothing_cat.jpg'),
                  _buildCategoryCard(context, 'Merchandise', 'c_merch', 'assets/images/merch_cat.jpg'),
                  _buildCategoryCard(context, 'Halloween 🎃', 'c_halloween', 'assets/images/halloween_cat.jpg'),
                  _buildCategoryCard(context, 'Signature Range', 'c_signature', 'assets/images/clothing_cat.jpg'), 
                  _buildCategoryCard(context, 'Portsmouth City', 'c_city', 'assets/images/portsmouth_cat.jpg'),
                  _buildCategoryCard(context, 'Pride 🏳️‍🌈', 'c_pride', 'assets/images/pride_cat.jpg'),
                  _buildCategoryCard(context, 'Graduation 🎓', 'c_grad', 'assets/images/graduation_cat.jpg'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, String id, String imagePath) {
    return GestureDetector(
      onTap: () {
        // NAV CHANGE: Use Named Route with Map Arguments
        Navigator.pushNamed(
          context, 
          '/collection', 
          arguments: {'id': id, 'title': title}
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.asset(
                  imagePath, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}