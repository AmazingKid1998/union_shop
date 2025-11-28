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
                  _buildCategoryCard(context, 'Clothing', 'c_clothing', 'https://via.placeholder.com/300x300/4B0082/ffffff?text=Clothing'),
                  _buildCategoryCard(context, 'Merchandise', 'c_merch', 'https://via.placeholder.com/300x300/2196f3/ffffff?text=Merch'),
                  _buildCategoryCard(context, 'Halloween 🎃', 'c_halloween', 'https://via.placeholder.com/300x300/ff9800/000000?text=Halloween'),
                  _buildCategoryCard(context, 'Signature Range', 'c_signature', 'https://via.placeholder.com/300x300/1a237e/ffffff?text=Signature'),
                  _buildCategoryCard(context, 'Portsmouth City', 'c_city', 'https://via.placeholder.com/300x300/607d8b/ffffff?text=City'),
                  _buildCategoryCard(context, 'Pride 🏳️‍🌈', 'c_pride', 'https://via.placeholder.com/300x300/FFC107/ffffff?text=Pride'),
                  _buildCategoryCard(context, 'Graduation 🎓', 'c_grad', 'https://via.placeholder.com/300x300/795548/ffffff?text=Graduation'),
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

  Widget _buildCategoryCard(BuildContext context, String title, String id, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionDetailPage(collectionId: id, title: title),
          ),
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
                child: Image.network(imageUrl, fit: BoxFit.cover),
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