import 'package:flutter/material.dart';
import 'product_search_delegate.dart'; // Import search logic

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7), 
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SECTION 1: OPENING HOURS ---
          const Text(
            'Opening Hours',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 15),
          
          Row(
            children: const [
              Icon(Icons.ac_unit, size: 16, color: Colors.lightBlue),
              SizedBox(width: 5),
              Text(
                'Winter Break Closure Dates',
                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blueGrey),
              ),
              SizedBox(width: 5),
              Icon(Icons.ac_unit, size: 16, color: Colors.lightBlue),
            ],
          ),
          const SizedBox(height: 10),
          
          _buildFooterText('Closing 4pm 19/12/2025', isBold: true),
          _buildFooterText('Reopening 10am 05/01/2026', isBold: true),
          const SizedBox(height: 10),
          _buildFooterText('Last post date: 12pm on 18/12/2025', isBold: true),
          
          const SizedBox(height: 15),
          const Text('-----------------------', style: TextStyle(color: Colors.blueGrey, letterSpacing: 2)),
          const SizedBox(height: 15),

          _buildFooterText('(Term Time)', isBold: true),
          const SizedBox(height: 5),
          _buildFooterText('Monday - Friday 10am - 4pm', isBold: true),
          
          const SizedBox(height: 15),
          _buildFooterText('(Outside of Term Time / Consolidation Weeks)', isBold: true),
          const SizedBox(height: 5),
          _buildFooterText('Monday - Friday 10am - 3pm', isBold: true),
          
          const SizedBox(height: 15),
          _buildFooterText('Purchase online 24/7', isBold: true),

          const SizedBox(height: 40),

          // --- SECTION 2: HELP AND INFORMATION ---
          const Text(
            'Help and Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 20),
          
          // SEARCH LINK (Now clickable!)
          _buildFooterLink('Search', onTap: () {
            showSearch(
              context: context, 
              delegate: ProductSearchDelegate()
            );
          }),
          
          const SizedBox(height: 15),
          _buildFooterLink('Terms & Conditions of Sale Policy'),

          const SizedBox(height: 40),

          // --- SECTION 3: LATEST OFFERS ---
          const Text(
            'Latest Offers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 15),
          
          Container(
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Email address',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0), 
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B0082), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)), 
              ),
              onPressed: () {},
              child: const Text(
                'SUBSCRIBE',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Updated Helper: Now accepts an onTap function
  Widget _buildFooterLink(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blueGrey[700],
          fontSize: 16,
          decoration: onTap != null ? TextDecoration.underline : null, // Underline clickable links
        ),
      ),
    );
  }

  Widget _buildFooterText(String text, {bool isBold = false}) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.blueGrey[700],
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontSize: 14,
      ),
    );
  }
}