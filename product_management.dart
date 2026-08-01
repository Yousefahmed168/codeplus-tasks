/// -------------------------
///  """ TASK: PRODUCT MANAGEMENT SYSTEM """
/// ------------------------------------------------
/// Demonstrates Dart Collections & Collection Methods
/// (where, map, fold, any, every, firstWhere, sort, Set)

// ── 1. Product class
class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.isAvailable,
  });

  @override
  String toString() =>
      'Product(id: $id, name: $name, price: $price, '
      'category: $category, available: $isAvailable)';
}

void main() {
  // ── 2. List of products (different categories & availability)
  final List<Product> products = [
    Product(id: 1, name: 'Laptop',     price: 45000, category: 'Electronics', isAvailable: true),
    Product(id: 2, name: 'Headphones', price: 1500,  category: 'Electronics', isAvailable: true),
    Product(id: 3, name: 'Math Book',  price: 250,   category: 'Education',   isAvailable: false),
    Product(id: 4, name: 'Pizza',      price: 120,   category: 'Food',        isAvailable: true),
    Product(id: 5, name: 'Smartphone', price: 25000, category: 'Electronics', isAvailable: false),
    Product(id: 6, name: 'Keyboard',   price: 800,   category: 'Electronics', isAvailable: true),
  ];

  print('═══════════════════════════════════════════════');
  print('         PRODUCT MANAGEMENT SYSTEM             ');
  print('═══════════════════════════════════════════════');

  // ── 1. Filter Available Products (where)
  final availableProducts = products.where((p) => p.isAvailable).toList();
  print('\n1) AVAILABLE PRODUCTS (where):');
  availableProducts.forEach((p) => print('   • ${p.name}'));

  // ── 2. Extract Product Names (map)
  final productNames = products.map((p) => p.name).toList();
  print('\n2) PRODUCT NAMES (map):');
  print('   $productNames');

  // ── 3. Available Electronics Products (where + map)
  final availableElectronicsNames = products
      .where((p) => p.isAvailable && p.category == 'Electronics')
      .map((p) => p.name)
      .toList();
  print('\n3) AVAILABLE ELECTRONICS (where + map):');
  print('   $availableElectronicsNames');

  // ── 4. Total price of all products (fold)
  final totalPrice = products.fold<double>(
    0.0,
    (sum, p) => sum + p.price,
  );
  print('\n4) TOTAL PRICE OF ALL PRODUCTS (fold):');
  print('   \$${totalPrice.toStringAsFixed(2)}');

  // ── 5. Total price of available products only (where + fold)
  final availableTotal = products
      .where((p) => p.isAvailable)
      .fold<double>(0.0, (sum, p) => sum + p.price);
  print('\n5) TOTAL PRICE OF AVAILABLE PRODUCTS (where + fold):');
  print('   \$${availableTotal.toStringAsFixed(2)}');

  // ── 6. Check if any product costs more than 20000 (any)
  final hasExpensiveProduct = products.any((p) => p.price > 20000);
  print('\n6) ANY PRODUCT > \$20000 (any):');
  print('   $hasExpensiveProduct');

  // ── 7. Check if all products cost more than 100 (every)
  final allAbove100 = products.every((p) => p.price > 100);
  print('\n7) ALL PRODUCTS > \$100 (every):');
  print('   $allAbove100');

  // ── 8. Find first Electronics product (firstWhere)
  final firstElectronics = products.firstWhere(
    (p) => p.category == 'Electronics',
    orElse: () => Product(id: -1, name: 'None', price: 0, category: '', isAvailable: false),
  );
  print('\n8) FIRST ELECTRONICS PRODUCT (firstWhere):');
  print('   ${firstElectronics.name}');

  // ── 9. Sort products from cheapest to most expensive (sort)
  final sortedProducts = [...products]..sort((a, b) => a.price.compareTo(b.price));
  print('\n9) PRODUCTS SORTED BY PRICE (sort):');
  sortedProducts.forEach((p) => print('   ${p.price.toStringAsFixed(2)}  ${p.name}'));

  // ── 10. Remove duplicate categories (Set)
  final List<String> categories = [
    'Electronics',
    'Education',
    'Electronics',
    'Food',
  ];
  final uniqueCategories = categories.toSet();
  print('\n10) UNIQUE CATEGORIES (Set):');
  print('   $uniqueCategories');

  print('\n═══════════════════════════════════════════════');
}
