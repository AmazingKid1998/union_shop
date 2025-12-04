import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/viewmodels/shop_viewmodel.dart';
import 'package:union_shop/models/product.dart';

void main() {
  // ---------------------------------------------------------------------------
  // 1. REPOSITORY TESTS (Edge Cases)
  // ---------------------------------------------------------------------------
  group('ProductRepository Extended Tests', () {
    late ProductRepository repository;

    setUp(() {
      repository = ProductRepository();
    });

    test('getProductById returns fallback (first product) when ID is invalid', () {
      // "non_existent_id" does not exist in the dummy data
      final product = repository.getProductById('non_existent_id');
      
      // Should return the first product in the list (Classic Hoodie)
      expect(product.id, 'p_classic_hoodie');
    });

    test('getProductsByCollection returns empty list for unknown collection', () {
      final items = repository.getProductsByCollection('c_unknown_collection');
      expect(items, isEmpty);
    });

    test('getSaleProducts returns strictly items with oldPrice', () {
      final saleItems = repository.getSaleProducts();
      
      // Verify every single item has an oldPrice
      for (var p in saleItems) {
        expect(p.oldPrice, isNotNull);
      }
      
      // Verify at least one sale item exists (sanity check)
      expect(saleItems.length, greaterThan(0));
    });
  });

  // ---------------------------------------------------------------------------
  // 2. VIEWMODEL TESTS (Sorting & Filtering Coverage)
  // ---------------------------------------------------------------------------
  group('ShopViewModel Extended Logic Tests', () {
    late ShopViewModel viewModel;

    setUp(() {
      viewModel = ShopViewModel();
      // Allow async constructor to finish loading data
      // (Though in the static repo it's technically sync, this is good practice)
      return Future.delayed(Duration.zero);
    });

    test('Filter: Price Ranges work correctly', () {
      // 1. Under £10
      final cheap = viewModel.getByCollection('c_merch', priceRangeName: 'Under £10');
      for (var p in cheap) expect(p.price, lessThan(10.0));

      // 2. £10 - £20
      final mid = viewModel.getByCollection('c_clothing', priceRangeName: '£10 - £20');
      for (var p in mid) {
        expect(p.price, greaterThanOrEqualTo(10.0));
        expect(p.price, lessThanOrEqualTo(20.0));
      }

      // 3. Over £20
      final expensive = viewModel.getByCollection('c_clothing', priceRangeName: 'Over £20');
      for (var p in expensive) expect(p.price, greaterThan(20.0));
    });

    test('Sorting: Price High to Low', () {
      final items = viewModel.getByCollection(
        'c_clothing', 
        sortOption: SortOption.priceHighToLow
      );

      for (int i = 0; i < items.length - 1; i++) {
        // Current item price should be >= next item price
        expect(items[i].price, greaterThanOrEqualTo(items[i + 1].price));
      }
    });

    test('Sorting: Name A-Z', () {
      final items = viewModel.getByCollection(
        'c_clothing', 
        sortOption: SortOption.nameAZ
      );

      for (int i = 0; i < items.length - 1; i++) {
        // Current title should compare less than or equal to next title
        expect(
          items[i].title.compareTo(items[i + 1].title), 
          lessThanOrEqualTo(0)
        );
      }
    });

    test('Sorting: Name Z-A', () {
      // Need to invoke the helper manually or ensure coverage for this case
      // Note: If you don't have this enum used in the UI, this tests the VM capability
      final items = viewModel.getByCollection(
        'c_clothing', 
        sortOption: SortOption.nameZA
      );

      for (int i = 0; i < items.length - 1; i++) {
         // Current title should compare greater than or equal to next title
        expect(
          items[i].title.compareTo(items[i + 1].title), 
          greaterThanOrEqualTo(0)
        );
      }
    });

    test('Search: Is case insensitive', () {
      // Search for "hoodie" (lowercase) should find "Classic Hoodie" (Title Case)
      final results = viewModel.search('hoodie');
      
      expect(results, isNotEmpty);
      expect(results.any((p) => p.title == 'Classic Hoodie'), isTrue);
    });

    test('Search: Partial matches work', () {
      // Search for "post" should find "Portsmouth City Postcard"
      final results = viewModel.search('post');
      
      expect(results, isNotEmpty);
      expect(results.any((p) => p.id == 'p_city_postcard'), isTrue);
    });
  });
}