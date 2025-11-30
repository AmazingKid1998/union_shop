import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/collections_page.dart';
import 'pages/print_shack_page.dart';
import 'pages/cart_page.dart';
import 'pages/login_page.dart';
import 'pages/sale_page.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
        '/shop': (context) => const CollectionsPage(),
        '/print-shack': (context) => const PrintShackPage(),
        '/cart': (context) => const CartPage(),
        '/login': (context) => const LoginPage(),
        '/sale': (context) => const SalePage(),
      },
    );
  }
}