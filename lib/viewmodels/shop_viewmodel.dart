import 'package:flutter/material.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

enum SortOption { priceLowToHigh, priceHighToLow, nameAZ, nameZA }

class ShopViewModel extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  
  List<Product> _products = [];
  List<Product> get products => _products;

  // Constructor loads data immediately
  ShopViewModel() {
    _loadProducts();
  }

  void _loadProducts() async {
    _products = await _productRepository.getAllProducts();
    notifyListeners();
  }

  // Helper methods that the UI calls
  List<Product> getByCollection(String id, {SortOption? sortOption, double? maxPrice}) {
    List<Product> items = _productRepository.getProductsByCollection(id);
    
    // 1. FILTERING (e.g. Max Price)
    if (maxPrice != null) {
      items = items.where((p) => p.price <= maxPrice).toList();
    }

    // 2. SORTING
    if (sortOption != null) {
      switch (sortOption) {
        case SortOption.priceLowToHigh:
          items.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortOption.priceHighToLow:
          items.sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortOption.nameAZ:
          items.sort((a, b) => a.title.compareTo(b.title));
          break;
        case SortOption.nameZA:
          items.sort((a, b) => b.title.compareTo(a.title));
          break;
      }
    }
    
    return items;
  }
  
  List<Product> getSaleItems() {
    return _productRepository.getSaleProducts();
  }
  
  Product getProductById(String id) {
    return _productRepository.getProductById(id);
  }

  List<Product> search(String query) {
    return _products.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}