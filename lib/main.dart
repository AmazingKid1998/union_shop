import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false, // Removes the 'debug' sash
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}