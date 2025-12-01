import 'package:flutter/material.dart';
import '../widgets/site_header.dart';
import '../widgets/site_footer.dart';

class PrintShackMenuPage extends StatelessWidget {
  const PrintShackMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                'The Print Shack',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Two Big Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 30,
                runSpacing: 30,
                alignment: WrapAlignment.center,
                children: [
                  _buildMenuCard(
                    context, 
                    'About Us', 
                    'Learn more about our printing services.',
                    Icons.info_outline,
                    '/print-shack/about'
                  ),
                  _buildMenuCard(
                    context, 
                    'Personalisation', 
                    'Start designing your custom gear now!',
                    Icons.edit,
                    '/print-shack/tool'
                  ),
                ],
              ),
            ),

            const SizedBox(height: 150),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String subtitle, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 300,
        // Removed fixed height: 200
        constraints: const BoxConstraints(minHeight: 200), // Minimum height instead
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF4B0082)),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}