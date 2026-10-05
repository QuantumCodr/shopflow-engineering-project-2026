/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Console Application
Description  : Console interface for ShopFlow.
------------------------------------------------------------
*/

import 'dart:io';

import 'package:shopflow/shopflow.dart';

void main() {
  final database = ShopFlowDatabase();

  final categoryRepository =
      SqliteCategoryRepository(database.database);

  final productRepository =
      SqliteProductRepository(database.database);

  final inventoryRepository =
      SqliteInventoryRepository(database.database);

  final categoryProductRepository =
      SqliteCategoryProductRepository(database.database);

  final categoryService =
      CategoryService(categoryRepository);

  final productService = ProductService(
    productRepository,
    categoryRepository,
  );

  final inventoryService = InventoryService(
    inventoryRepository,
    productRepository,
  );

  final categoryProductService = CategoryProductService(
    categoryProductRepository,
    categoryRepository,
    productRepository,
  );

  try {
    _runApplication(
      categoryService: categoryService,
      productService: productService,
      inventoryService: inventoryService,
      categoryProductService: categoryProductService,
    );
  } finally {
    database.close();
  }
}

void _runApplication({
  required CategoryService categoryService,
  required ProductService productService,
  required InventoryService inventoryService,
  required CategoryProductService categoryProductService,
}) {
  print('========================================');
  print('              SHOPFLOW');
  print('     Small Business Management System');
  print('========================================');

  while (true) {
    print('');
    print('1. Categories');
    print('2. Products');
    print('3. Inventory');
    print('0. Exit');

    final option = _readInteger('Select an option: ');

    try {
      switch (option) {
        case 1:
          _categoryMenu(
            categoryService,
            categoryProductService,
          );
          break;

        case 2:
          _productMenu(
            productService,
            categoryProductService,
          );
          break;

        case 3:
          _inventoryMenu(
            inventoryService,
            productService,
          );
          break;

        case 0:
          print('ShopFlow closed.');
          return;

        default:
          print('Invalid option.');
      }
    } on ShopFlowException catch (error) {
      print('');
      print(
        'ERROR [${error.code}]: ${error.message}',
      );
    } catch (error) {
      print('');
      print('UNEXPECTED ERROR: $error');
    }
  }
}

void _categoryMenu(
  CategoryService categoryService,
  CategoryProductService categoryProductService,
) {
  while (true) {
    print('');
    print('========== CATEGORIES ==========');
    print('1. Create category');
    print('2. List categories');
    print('3. Find category');
    print('4. Search categories');
    print('5. Edit category');
    print('6. Activate category');
    print('7. Deactivate category');
    print('8. View products');
    print('9. Add product');
    print('10. Remove product');
    print('0. Back');

    final option = _readInteger('Select an option: ');

    try {
      switch (option) {
        case 1:
          _createCategory(categoryService);
          break;

        case 2:
          _listCategories(categoryService);
          break;

        case 3:
          _findCategory(categoryService);
          break;

        case 4:
          _searchCategories(categoryService);
          break;

        case 5:
          _editCategory(categoryService);
          break;

        case 6:
          _activateCategory(categoryService);
          break;

        case 7:
          _deactivateCategory(categoryService);
          break;

        case 8:
          _viewCategoryProducts(
            categoryService,
            categoryProductService,
          );
          break;

        case 9:
          _addProductToCategory(
            categoryProductService,
          );
          break;

        case 10:
          _removeProductFromCategory(
            categoryProductService,
          );
          break;

        case 0:
          return;

        default:
          print('Invalid option.');
      }
    } on ShopFlowException catch (error) {
      print('');
      print(
        'ERROR [${error.code}]: ${error.message}',
      );
    } catch (error) {
      print('');
      print('UNEXPECTED ERROR: $error');
    }
  }
}

void _productMenu(
  ProductService productService,
  CategoryProductService categoryProductService,
) {
  while (true) {
    print('');
    print('========== PRODUCTS ==========');
    print('1. Create product');
    print('2. List products');
    print('3. Find product');
    print('4. Search products');
    print('5. Edit product');
    print('6. Activate product');
    print('7. Deactivate product');
    print('8. View categories');
    print('9. Add to category');
    print('10. Remove from category');
    print('0. Back');

    final option = _readInteger('Select an option: ');

    try {
      switch (option) {
        case 1:
          _createProduct(productService);
          break;

        case 2:
          _listProducts(productService);
          break;

        case 3:
          _findProduct(productService);
          break;

        case 4:
          _searchProducts(productService);
          break;

        case 5:
          _editProduct(productService);
          break;

        case 6:
          _activateProduct(productService);
          break;

        case 7:
          _deactivateProduct(productService);
          break;

        case 8:
          _viewProductCategories(
            productService,
            categoryProductService,
          );
          break;

        case 9:
          _addProductToCategory(
            categoryProductService,
          );
          break;

        case 10:
          _removeProductFromCategory(
            categoryProductService,
          );
          break;

        case 0:
          return;

        default:
          print('Invalid option.');
      }
    } on ShopFlowException catch (error) {
      print('');
      print(
        'ERROR [${error.code}]: ${error.message}',
      );
    } catch (error) {
      print('');
      print('UNEXPECTED ERROR: $error');
    }
  }
}

void _inventoryMenu(
  InventoryService inventoryService,
  ProductService productService,
) {
  while (true) {
    print('');
    print('========== INVENTORY ==========');
    print('1. View stock');
    print('2. Receive stock');
    print('3. Adjust stock');
    print('4. Low-stock products');
    print('5. Stock movement history');
    print('0. Back');

    final option = _readInteger('Select an option: ');

    try {
      switch (option) {
        case 1:
          _viewStock(inventoryService);
          break;

        case 2:
          _receiveStock(inventoryService);
          break;

        case 3:
          _adjustStock(inventoryService);
          break;

        case 4:
          _lowStockProducts(inventoryService);
          break;

        case 5:
          _stockMovementHistory(inventoryService);
          break;

        case 0:
          return;

        default:
          print('Invalid option.');
      }
    } on ShopFlowException catch (error) {
      print('');
      print(
        'ERROR [${error.code}]: ${error.message}',
      );
    } catch (error) {
      print('');
      print('UNEXPECTED ERROR: $error');
    }
  }
}

void _createCategory(
  CategoryService service,
) {
  print('');
  final name = _readText('Category name: ');
  final description = _readOptionalText(
    'Description: ',
  );

  final category = service.create(
    name: name,
    description: description,
  );

  print(
    'Category created successfully. ID: ${category.id}',
  );
}

void _listCategories(
  CategoryService service,
) {
  final categories = service.findAll();

  print('');

  if (categories.isEmpty) {
    print('No categories found.');
    return;
  }

  for (final category in categories) {
    print(
      '${category.id} | ${category.name} | '
      '${category.active ? 'ACTIVE' : 'INACTIVE'}',
    );
  }
}

void _findCategory(
  CategoryService service,
) {
  final id = _readInteger('Category ID: ');
  final category = service.findById(id);

  if (category == null) {
    throw const NotFoundException(
      message: 'Category not found.',
    );
  }

  print('');
  print('ID: ${category.id}');
  print('Name: ${category.name}');
  print(
    'Description: '
    '${category.description ?? 'N/A'}',
  );
  print(
    'Status: '
    '${category.active ? 'ACTIVE' : 'INACTIVE'}',
  );
  print('Created: ${category.createdAt}');
  print('Updated: ${category.updatedAt}');
}

void _searchCategories(
  CategoryService service,
) {
  final query = _readText('Search: ');
  final categories = service.search(query);

  print('');

  if (categories.isEmpty) {
    print('No categories found.');
    return;
  }

  for (final category in categories) {
    print(
      '${category.id} | ${category.name} | '
      '${category.active ? 'ACTIVE' : 'INACTIVE'}',
    );
  }
}

void _editCategory(
  CategoryService service,
) {
  final id = _readInteger('Category ID: ');
  final existing = service.findById(id);

  if (existing == null) {
    throw const NotFoundException(
      message: 'Category not found.',
    );
  }

  print(
    'Current name: ${existing.name}',
  );

  final name = _readOptionalText(
    'New name: ',
  );

  print(
    'Current description: '
    '${existing.description ?? 'N/A'}',
  );

  final description = _readOptionalText(
    'New description: ',
  );

  final category = service.update(
    id: id,
    name: name == null || name.isEmpty
        ? existing.name
        : name,
    description: description ?? existing.description
        
  );

  print(
    'Category updated successfully. ID: ${category.id}',
  );
}

void _activateCategory(
  CategoryService service,
) {
  final id = _readInteger('Category ID: ');

  service.activate(id);

  print('Category activated successfully.');
}

void _deactivateCategory(
  CategoryService service,
) {
  final id = _readInteger('Category ID: ');

  service.deactivate(id);

  print('Category deactivated successfully.');
}

void _viewCategoryProducts(
  CategoryService categoryService,
  CategoryProductService relationshipService,
) {
  final categoryId = _readInteger('Category ID: ');

  final category = categoryService.findById(categoryId);

  if (category == null) {
    throw const NotFoundException(
      message: 'Category not found.',
    );
  }

  final products =
      relationshipService.findProductsByCategory(
    categoryId,
  );

  print('');
  print('Category: ${category.name}');

  if (products.isEmpty) {
    print('No products assigned.');
    return;
  }

  for (final product in products) {
    print(
      '${product.id} | ${product.name} | '
      'Sell: Le ${product.sellingPrice} | '
      '${product.active ? 'ACTIVE' : 'INACTIVE'}',
    );
  }
}

void _addProductToCategory(
  CategoryProductService service,
) {
  final categoryId =
      _readInteger('Category ID: ');

  final productId =
      _readInteger('Product ID: ');

  service.assignProductToCategory(
    categoryId,
    productId,
  );

  print(
    'Product assigned to category successfully.',
  );
}

void _removeProductFromCategory(
  CategoryProductService service,
) {
  final categoryId =
      _readInteger('Category ID: ');

  final productId =
      _readInteger('Product ID: ');

  service.removeProductFromCategory(
    categoryId,
    productId,
  );

  print(
    'Product removed from category successfully.',
  );
}

void _createProduct(
  ProductService service,
) {
  print('');

  final name = _readText('Product name: ');
  final sku = _readOptionalText(
    'SKU (optional): ',
  );

  final unit = _readProductUnit();

  final costPrice = _readInteger(
    'Cost price: ',
  );

  final sellingPrice = _readInteger(
    'Selling price: ',
  );

  final reorderLevel = _readInteger(
    'Reorder level: ',
  );

  final product = service.create(
    name: name,
    sku: sku,
    unit: unit,
    costPrice: costPrice,
    sellingPrice: sellingPrice,
    reorderLevel: reorderLevel,
  );

  print(
    'Product created successfully. ID: ${product.id}',
  );
}

void _listProducts(
  ProductService service,
) {
  final products = service.findAll();

  print('');

  if (products.isEmpty) {
    print('No products found.');
    return;
  }

  for (final product in products) {
    print(
      '${product.id} | ${product.name} | '
      'SKU: ${product.sku ?? 'N/A'} | '
      'Unit: ${product.unit} | '
      'Sell: Le ${product.sellingPrice} | '
      '${product.active ? 'ACTIVE' : 'INACTIVE'}',
    );
  }
}

void _findProduct(
  ProductService service,
) {
  final id = _readInteger('Product ID: ');
  final product = service.findById(id);

  if (product == null) {
    throw const NotFoundException(
      message: 'Product not found.',
    );
  }

  print('');
  print('ID: ${product.id}');
  print('Name: ${product.name}');
  print('SKU: ${product.sku ?? 'N/A'}');
  print('Unit: ${product.unit}');
  print('Cost price: Le ${product.costPrice}');
  print('Selling price: Le ${product.sellingPrice}');
  print('Reorder level: ${product.reorderLevel}');
  print(
    'Status: '
    '${product.active ? 'ACTIVE' : 'INACTIVE'}',
  );
  print('Created: ${product.createdAt}');
  print('Updated: ${product.updatedAt}');
}

void _searchProducts(
  ProductService service,
) {
  final query = _readText('Search: ');
  final products = service.search(query);

  print('');

  if (products.isEmpty) {
    print('No products found.');
    return;
  }

  for (final product in products) {
    print(
      '${product.id} | ${product.name} | '
      'SKU: ${product.sku ?? 'N/A'} | '
      'Unit: ${product.unit} | '
      'Sell: Le ${product.sellingPrice} | '
      '${product.active ? 'ACTIVE' : 'INACTIVE'}',
    );
  }
}

void _editProduct(
  ProductService service,
) {
  final id = _readInteger('Product ID: ');
  final existing = service.findById(id);

  if (existing == null) {
    throw const NotFoundException(
      message: 'Product not found.',
    );
  }

  print('Current name: ${existing.name}');

  final name = _readOptionalText(
    'New name: ',
  );

  print(
    'Current SKU: ${existing.sku ?? 'N/A'}',
  );

  final sku = _readOptionalText(
    'New SKU: ',
  );

  print('Current unit: ${existing.unit}');
  final unit = _readOptionalProductUnit(
    existing.unit,
  );

  print(
    'Current cost price: Le ${existing.costPrice}',
  );

  final costPrice = _readOptionalInteger(
    'New cost price: ',
  );

  print(
    'Current selling price: '
    'Le ${existing.sellingPrice}',
  );

  final sellingPrice = _readOptionalInteger(
    'New selling price: ',
  );

  print(
    'Current reorder level: '
    '${existing.reorderLevel}',
  );

  final reorderLevel = _readOptionalInteger(
    'New reorder level: ',
  );

  final product = service.update(
    id: id,
    name: name == null || name.isEmpty
        ? existing.name
        : name,
    sku: sku == null
        ? existing.sku
        : sku.isEmpty
            ? null
            : sku,
    unit: unit,
    costPrice: costPrice ?? existing.costPrice,
    sellingPrice:
        sellingPrice ?? existing.sellingPrice,
    reorderLevel:
        reorderLevel ?? existing.reorderLevel,
  );

  print(
    'Product updated successfully. ID: ${product.id}',
  );
}

void _activateProduct(
  ProductService service,
) {
  final id = _readInteger('Product ID: ');

  service.activate(id);

  print('Product activated successfully.');
}

void _deactivateProduct(
  ProductService service,
) {
  final id = _readInteger('Product ID: ');

  service.deactivate(id);

  print('Product deactivated successfully.');
}

void _viewProductCategories(
  ProductService productService,
  CategoryProductService relationshipService,
) {
  final productId = _readInteger('Product ID: ');

  final product = productService.findById(productId);

  if (product == null) {
    throw const NotFoundException(
      message: 'Product not found.',
    );
  }

  final categories =
      relationshipService.findCategoriesByProduct(
    productId,
  );

  print('');
  print('Product: ${product.name}');

  if (categories.isEmpty) {
    print('No categories assigned.');
    return;
  }

  for (final category in categories) {
    print(
      '${category.id} | ${category.name} | '
      '${category.active ? 'ACTIVE' : 'INACTIVE'}',
    );
  }
}

void _viewStock(
  InventoryService service,
) {
  final productId =
      _readInteger('Product ID: ');

  final inventory = service.getStock(productId);

  print(
    'Product ${inventory.productId}: '
    '${inventory.quantity} units',
  );
}

void _receiveStock(
  InventoryService service,
) {
  final productId =
      _readInteger('Product ID: ');

  final quantity =
      _readInteger('Quantity received: ');

  final reference = _readOptionalText(
    'Reference (optional): ',
  );

  service.receiveStock(
    productId,
    quantity,
    reference: reference,
  );

  print('Stock received successfully.');
}

void _adjustStock(
  InventoryService service,
) {
  final productId =
      _readInteger('Product ID: ');

  final quantity =
      _readInteger('Adjustment quantity: ');

  final reference = _readOptionalText(
    'Reference (optional): ',
  );

  service.adjustStock(
    productId,
    quantity,
    reference: reference,
  );

  print('Stock adjusted successfully.');
}

void _lowStockProducts(
  InventoryService service,
) {
  final products =
      service.findLowStockProducts();

  print('');

  if (products.isEmpty) {
    print('No low-stock products.');
    return;
  }

  print('Low-stock products:');

  for (final product in products) {
    final inventory =
        service.getStock(product.id!);

    print(
      '${product.id} | ${product.name} | '
      'Stock: ${inventory.quantity} | '
      'Reorder: ${product.reorderLevel}',
    );
  }
}

void _stockMovementHistory(
  InventoryService service,
) {
  final productId =
      _readInteger('Product ID: ');

  final movements =
      service.findMovements(productId);

  print('');

  if (movements.isEmpty) {
    print('No stock movements found.');
    return;
  }

  for (final movement in movements) {
    print(
      '${movement.id} | '
      '${movement.movementType} | '
      '${movement.quantity} | '
      '${movement.reference ?? 'N/A'} | '
      '${movement.createdAt}',
    );
  }
}

ProductUnit _readProductUnit() {
  print('');
  print('Available units:');

  final units = ProductUnit.values;

  for (var i = 0; i < units.length; i++) {
    print('${i + 1}. ${units[i]}');
  }

  while (true) {
    final input = stdin.readLineSync()?.trim() ?? '';

    final choice = int.tryParse(input);

    if (choice != null &&
        choice >= 1 &&
        choice <= units.length) {
      return units[choice - 1];
    }

    print('Please enter a valid whole number.');
    print('Select unit: ');
  }
}

ProductUnit _readOptionalProductUnit(
  ProductUnit current,
) {
  print('');
  print('Available units:');

  final units = ProductUnit.values;

  for (var i = 0; i < units.length; i++) {
    print('${i + 1}. ${units[i]}');
  }

  print(
    'Press Enter to keep ${current.label}.',
  );

  while (true) {
    final input = stdin.readLineSync()?.trim() ?? '';

    if (input.isEmpty) {
      return current;
    }

    final choice = int.tryParse(input);

    if (choice != null &&
        choice >= 1 &&
        choice <= units.length) {
      return units[choice - 1];
    }

    print('Please enter a valid whole number.');
    print('Select unit: ');
  }
}

String _readText(String prompt) {
  stdout.write(prompt);

  while (true) {
    final value = stdin.readLineSync()?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    print('Value cannot be empty.');
    stdout.write(prompt);
  }
}

String? _readOptionalText(String prompt) {
  stdout.write(prompt);

  final value = stdin.readLineSync()?.trim() ?? '';

  if (value.isEmpty) {
    return null;
  }

  return value;
}

int _readInteger(String prompt) {
  stdout.write(prompt);

  while (true) {
    final input = stdin.readLineSync()?.trim() ?? '';
    final value = int.tryParse(input);

    if (value != null) {
      return value;
    }

    print('Please enter a valid whole number.');
    stdout.write(prompt);
  }
}

int? _readOptionalInteger(String prompt) {
  stdout.write(prompt);

  while (true) {
    final input = stdin.readLineSync()?.trim() ?? '';

    if (input.isEmpty) {
      return null;
    }

    final value = int.tryParse(input);

    if (value != null) {
      return value;
    }

    print('Please enter a valid whole number.');
    stdout.write(prompt);
  }
}