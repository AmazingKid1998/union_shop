import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  group('ShopViewModel - Basic Functionality Tests (Simplified)', () {
    late ShopViewModel viewModel;

    setUp(() {
      viewModel = ShopViewModel();
    });

    test('Products list is populated after initialization', () async {
      // Wait for the asynchronous product loading
      await Future.delayed(const Duration(milliseconds: 200)); 
      
      expect(viewModel.products.isNotEmpty, isTrue);
    });

    test('Search finds the Classic Hoodie (case insensitive)', async {
      await Future.delayed(const Duration(milliseconds: 200));
      
      final results = viewModel.search('hoodie');
      
      expect(results, isNotEmpty);
      expect(results.any((p) => p.title.toLowerCase().contains('hoodie')), isTrue);
    });

    test('Sorting by price low to high correctly reorders items', () async {
      await Future.delayed(const Duration(milliseconds: 200));
      
      final sorted = viewModel.getByCollection(
        'c_merch', // Use a collection with varied prices
        sortOption: SortOption.priceLowToHigh,
      );
      
      for (int i = 0; i < sorted.length - 1; i++) {
        expect(sorted[i].price <= sorted[i + 1].price, isTrue, reason: 'Item ${i} is not cheaper than item ${i+1}');
      }
    });
  });
}