import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';

void main() {
  group('ShopViewModel Logic Tests', () {
    late ShopViewModel viewModel;

    setUp(() {
      viewModel = ShopViewModel();
    });

    // --- TEST 1: INITIALIZATION ---
    test('Loads products on initialization', () async {
      // Wait for the async constructor to finish fetching data
      await Future.delayed(const Duration(milliseconds: 50));
      expect(viewModel.products.isNotEmpty, true);
    });

    // --- TEST 2: SEARCH LOGIC ---
    test('Search filters by title (case insensitive)', () async {
      await Future.delayed(const Duration(milliseconds: 50));

      // 1. Search for "hoodie"
      final results = viewModel.search('hoodie');
      
      // Verify
      expect(results.isNotEmpty, true);
      expect(results.any((p) => p.title.toLowerCase().contains('hoodie')), true);
      
      // 2. Search for nonsense
      final emptyResults = viewModel.search('XyZ_Not_Real');
      expect(emptyResults.isEmpty, true);
    });

    // --- TEST 3: COLLECTION FILTERING ---
    test('GetByCollection returns correct items', () {
      final clothing = viewModel.getByCollection('c_clothing');
      expect(clothing.isNotEmpty, true);
      
      for (var item in clothing) {
        expect(item.collectionId, 'c_clothing');
      }
    });

    // --- TEST 4: SALE ITEMS ---
    test('GetSaleItems returns only discounted products', () {
      final saleItems = viewModel.getSaleItems();
      expect(saleItems.isNotEmpty, true);
      
      for (var item in saleItems) {
        expect(item.oldPrice, isNotNull);
      }
    });
    
    // --- TEST 5: GET BY ID (FIXED) ---
    test('GetProductById returns correct product', () async {
      // 1. Wait for data to load
      await Future.delayed(const Duration(milliseconds: 50));
      
      // 2. Safely get a valid ID from the loaded list
      if (viewModel.products.isEmpty) {
        fail('No products loaded, cannot test GetById');
      }
      
      final realProduct = viewModel.products.first;
      final realId = realProduct.id;

      // 3. Now test the method with a GUARANTEED valid ID
      final foundProduct = viewModel.getProductById(realId);
      
      expect(foundProduct.title, realProduct.title);
      expect(foundProduct.id, realId);
    });
  });
}