import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/repositories/product_repository.dart'; // Ensure you're using real repository

void main() {
  group('ShopViewModel - Basic Functionality Tests', () {
    late ShopViewModel viewModel;

    setUp(() {
      viewModel = ShopViewModel();
    });

    // We keep this check simple to ensure async load completes
    test('Products list is populated after initialization', () async {
      // Wait long enough for the repository to load the products
      await Future.delayed(const Duration(milliseconds: 200)); 
      
      expect(viewModel.products.isNotEmpty, isTrue);
    });

    test('Search finds the Classic Hoodie (case insensitive)', () async {
      // Await load before searching
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Search for a known product with mixed casing
      final results = viewModel.search('cLaSsIc hOoDiE');
      
      expect(results, isNotEmpty);
      expect(results.first.id, 'p_classic_hoodie');
    });

    test('GetByCollection finds items for the clothing category', () async {
      // Await load before calling collection methods
      await Future.delayed(const Duration(milliseconds: 200));
      
      final clothing = viewModel.getByCollection('c_clothing');
      
      expect(clothing, isNotEmpty);
      // Ensure all results belong to the requested collection
      expect(clothing.every((p) => p.collectionIds.contains('c_clothing')), isTrue);
    });
  });
}