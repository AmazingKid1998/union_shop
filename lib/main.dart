import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'viewmodels/shop_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';

// Pages
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/collections_page.dart';
import 'pages/print_shack_page.dart'; // The Tool
import 'pages/print_shack_menu_page.dart'; // The Menu
import 'pages/print_shack_about_page.dart'; // The Info
import 'pages/cart_page.dart';
import 'pages/login_page.dart';
import 'pages/sale_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      child: const UnionShopApp(),
    ),
  );
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
        '/collection':(context)=> const CollectionsPage(),
        '/cart': (context) => const CartPage(),
        '/login': (context) => const LoginPage(),
        '/sale': (context) => const SalePage(),
        
        // --- PRINT SHACK ROUTES ---
        '/print-shack': (context) => const PrintShackMenuPage(), // Main Landing
        '/print-shack/tool': (context) => const PrintShackPage(), // The Editor
        '/print-shack/about': (context) => const PrintShackAboutPage(), // The Info
      },
    );
  }
}