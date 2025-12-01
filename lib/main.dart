import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // REQUIRED FOR MVVM ARCHITECTURE

// MVVM Imports
import 'viewmodels/shop_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';

// View Imports
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/collections_page.dart';
import 'pages/print_shack_page.dart';
import 'pages/cart_page.dart';
import 'pages/login_page.dart';
import 'pages/sale_page.dart';

void main() {
  runApp(
    // Inject ViewModels here
    MultiProvider(
      providers: [
        // Shop data and filtering logic
        ChangeNotifierProvider(create: (_) => ShopViewModel()),
        // Cart state management logic
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
        '/collection':(context)=>const CollectionsPage(),
        '/print-shack': (context) => const PrintShackPage(),
        '/cart': (context) => const CartPage(),
        '/login': (context) => const LoginPage(),
        '/sale': (context) => const SalePage(),
      },
    );
  }
}