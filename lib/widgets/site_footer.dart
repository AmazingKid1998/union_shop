import 'package:flutter/material.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        children: const [
          Text('The Union Shop', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('University of Portsmouth Student Union'),
          SizedBox(height: 10),
          Text('© 2025 All Rights Reserved'),
        ],
      ),
    );
  }
}