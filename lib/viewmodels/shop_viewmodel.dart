import 'package:flutter/material.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ShopViewModel extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  
  List<Product> _products = [];
  List<Product> get products => _products;

  // Load data immediately upon creation
  ShopViewModel() {
    _loadProducts();
  }

  void _loadProducts() async {
    _products = await _productRepository.getAllProducts();
    notifyListeners();
  }

  // Helper methods that the UI calls
  List<Product> getByCollection(String id) {
    return _productRepository.getProductsByCollection(id);
  }
  
  List<Product> getSaleItems() {
    return _productRepository.getSaleProducts();
  }
  
  // FIX: EXPOSE getProductById method for use by tests and potentially UI/navigation
  Product getProductById(String id) {
    return _productRepository.getProductById(id);
  }

  // Search logic
  List<Product> search(String query) {
    return _products.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}