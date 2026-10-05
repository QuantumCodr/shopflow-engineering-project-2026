/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Console Application
Description  : Console interface for the ShopFlow system.
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

  final categoryService =
      CategoryService(categoryRepository);

  final productService =
      ProductService(
        productRepository,
        categoryRepository,
      );

  final inventoryService =
      InventoryService(
        inventoryRepository,
        productRepository,
      );

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
    print('');

    stdout.write('Select an option: ');
    final choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          _categoryMenu(categoryService);
          break;

        case '2':
          _productMenu(productService);
          break;

        case '3':
          _inventoryMenu(
            inventoryService,
            productService,
          );
          break;

        case '0':
          database.close();
          print('ShopFlow closed.');
          return;

        default:
          print('Invalid option.');
      }
    } on ShopFlowException catch (error) {
      print('');
      print('ERROR [${error.code}]: ${error.message}');
    } catch (error) {
      print('');
      print('UNEXPECTED ERROR: $error');
    }
  }
}

void _categoryMenu(CategoryService service) {
  while (true) {
    print('');
    print('========== CATEGORIES ==========');
    print('1. Create category');
    print('2. List categories');
    print('3. Search categories');
    print('4. Activate category');
    print('5. Deactivate category');
    print('0. Back');

    stdout.write('Select an option: ');
    final choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          stdout.write('Category name: ');
          final name = stdin.readLineSync() ?? '';

          stdout.write('Description: ');
          final description = stdin.readLineSync();

          final category = service.create(
            name: name,
            description: description,
          );

          print(
            'Category created successfully. '
            'ID: ${category.id}',
          );
          break;

        case '2':
          final categories = service.findAll();

          if (categories.isEmpty) {
            print('No categories found.');
            break;
          }

          for (final category in categories) {
            print(
              '${category.id} | '
              '${category.name} | '
              '${category.active ? "ACTIVE" : "INACTIVE"}',
            );
          }
          break;

        case '3':
          stdout.write('Search: ');
          final query = stdin.readLineSync() ?? '';

          final categories = service.search(query);

          if (categories.isEmpty) {
            print('No categories found.');
            break;
          }

          for (final category in categories) {
            print(
              '${category.id} | '
              '${category.name} | '
              '${category.active ? "ACTIVE" : "INACTIVE"}',
            );
          }
          break;

        case '4':
          final id = _readInteger('Category ID: ');

          service.activate(id);

          print('Category activated successfully.');
          break;

        case '5':
          final id = _readInteger('Category ID: ');

          service.deactivate(id);

          print('Category deactivated successfully.');
          break;

        case '0':
          return;

        default:
          print('Invalid option.');
      }
    } on ShopFlowException catch (error) {
      print(
        'ERROR [${error.code}]: ${error.message}',
      );
    } catch (error) {
      print('UNEXPECTED ERROR: $error');
    }
  }
}

void _productMenu(ProductService service) {
  while (true) {
    print('');
    print('========== PRODUCTS ==========');
    print('1. Create product');
    print('2. List products');
    print('3. Search products');
    print('4. Activate product');
    print('5. Deactivate product');
    print('0. Back');

    stdout.write('Select an option: ');
    final choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          stdout.write('Product name: ');
          final name = stdin.readLineSync() ?? '';

          stdout.write('SKU (optional): ');
          final skuInput = stdin.readLineSync()?.trim();

          final unit = _readProductUnit();

          final costPrice =
              _readInteger('Cost price: ');

          final sellingPrice =
              _readInteger('Selling price: ');

          final reorderLevel =
              _readInteger('Reorder level: ');

          final product = service.create(
            name: name,
            sku: skuInput == null || skuInput.isEmpty
                ? null
                : skuInput,
            unit: unit,
            costPrice: costPrice,
            sellingPrice: sellingPrice,
            reorderLevel: reorderLevel,
          );

          print(
            'Product created successfully. '
            'ID: ${product.id}',
          );
          break;

        case '2':
          final products = service.findAll();

          if (products.isEmpty) {
            print('No products found.');
            break;
          }

          for (final product in products) {
            print(
              '${product.id} | '
              '${product.name} | '
              'SKU: ${product.sku ?? "N/A"} | '
              'Unit: ${product.unit.label} | '
              'Sell: Le ${product.sellingPrice} | '
              '${product.active ? "ACTIVE" : "INACTIVE"}',
            );
          }
          break;

        case '3':
          stdout.write('Search: ');
          final query = stdin.readLineSync() ?? '';

          final products = service.search(query);

          if (products.isEmpty) {
            print('No products found.');
            break;
          }

          for (final product in products) {
            print(
              '${product.id} | '
              '${product.name} | '
              'SKU: ${product.sku ?? "N/A"} | '
              'Unit: ${product.unit.label} | '
              'Sell: Le ${product.sellingPrice} | '
              '${product.active ? "ACTIVE" : "INACTIVE"}',
            );
          }
          break;

        case '4':
          final id = _readInteger('Product ID: ');

          service.activate(id);

          print('Product activated successfully.');
          break;

        case '5':
          final id = _readInteger('Product ID: ');

          service.deactivate(id);

          print('Product deactivated successfully.');
          break;

        case '0':
          return;

        default:
          print('Invalid option.');
      }
    } on ShopFlowException catch (error) {
      print(
        'ERROR [${error.code}]: ${error.message}',
      );
    } catch (error) {
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
    print('0. Back');

    stdout.write('Select an option: ');
    final choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          final id = _readInteger('Product ID: ');

          final inventory =
              inventoryService.getStock(id);

          print(
            'Product ${inventory.productId}: '
            '${inventory.quantity} units',
          );
          break;

        case '2':
          final id = _readInteger('Product ID: ');

          final quantity =
              _readInteger('Quantity received: ');

          stdout.write('Reference (optional): ');
          final reference = stdin.readLineSync();

          inventoryService.receiveStock(
            id,
            quantity,
            reference: reference,
          );

          print('Stock received successfully.');
          break;

        case '3':
          final id = _readInteger('Product ID: ');

          final quantity =
              _readInteger('Adjustment quantity (+/-): ');

          stdout.write('Reference (optional): ');
          final reference = stdin.readLineSync();

          inventoryService.adjustStock(
            id,
            quantity,
            reference: reference,
          );

          print('Inventory adjusted successfully.');
          break;

        case '4':
          final ids =
              inventoryService.findLowStockProductIds();

          if (ids.isEmpty) {
            print('No low-stock products.');
            break;
          }

          print('Low-stock products:');

          for (final id in ids) {
            final product =
                productService.findById(id);

            if (product != null) {
              final stock =
                  inventoryService.getStock(id);

              print(
                '${product.id} | '
                '${product.name} | '
                'Stock: ${stock.quantity} | '
                'Reorder: ${product.reorderLevel}',
              );
            }
          }
          break;

        case '0':
          return;

        default:
          print('Invalid option.');
      }
    } on ShopFlowException catch (error) {
      print(
        'ERROR [${error.code}]: ${error.message}',
      );
    } catch (error) {
      print('UNEXPECTED ERROR: $error');
    }
  }
}

ProductUnit _readProductUnit() {
  print('');
  print('Available units:');

  final units = ProductUnit.values;

  for (var index = 0; index < units.length; index++) {
    print(
      '${index + 1}. ${units[index].label}',
    );
  }

  while (true) {
    final choice =
        _readInteger('Select unit: ');

    final index = choice - 1;

    if (index >= 0 && index < units.length) {
      return units[index];
    }

    print('Invalid unit selection.');
  }
}

int _readInteger(String prompt) {
  while (true) {
    stdout.write(prompt);

    final input = stdin.readLineSync()?.trim();

    final value = int.tryParse(input ?? '');

    if (value != null) {
      return value;
    }

    print('Please enter a valid whole number.');
  }
}