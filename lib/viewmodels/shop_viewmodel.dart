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
  List<Product> getByCollection(String id, {SortOption? sortOption, double? maxPrice, String? priceRangeName}) {
    List<Product> items = _productRepository.getProductsByCollection(id);
    
    // 1. FILTERING (Now based on Dropdown selection and price range)
    if (priceRangeName != null) {
      if (priceRangeName == 'Under £10') {
        items = items.where((p) => p.price < 10.00).toList();
      } else if (priceRangeName == '£10 - £20') {
        items = items.where((p) => p.price >= 10.00 && p.price <= 20.00).toList();
      } else if (priceRangeName == 'Over £20') {
        items = items.where((p) => p.price > 20.00).toList();
      }
      // If 'All Prices', no filter is applied
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