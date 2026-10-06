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

  final categoryRepository = SqliteCategoryRepository(database.database);

  final productRepository = SqliteProductRepository(database.database);

  final inventoryRepository = SqliteInventoryRepository(database.database);

  final categoryProductRepository = SqliteCategoryProductRepository(
    database.database,
  );

  final saleRepository = SqliteSaleRepository(database.database);

  final saleItemRepository = SqliteSaleItemRepository(database.database);

  final categoryService = CategoryService(categoryRepository);

  final productService = ProductService(productRepository, categoryRepository);

  final inventoryService = InventoryService(
    inventoryRepository,
    productRepository,
    database,
  );

  final categoryProductService = CategoryProductService(
    categoryProductRepository,
    categoryRepository,
    productRepository,
  );

  final saleService = SaleService(
    saleRepository,
    saleItemRepository,
    productRepository,
    inventoryRepository,
    database,
    taxRate: 0.10,
  );

  final reportService = ReportService(
    saleService,
    productService,
    inventoryService,
  );

  try {
    _runApplication(
      categoryService: categoryService,
      productService: productService,
      inventoryService: inventoryService,
      categoryProductService: categoryProductService,
      saleService: saleService,
      reportService: reportService,
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
  required SaleService saleService,
  required ReportService reportService,
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
    print('4. Point of Sale');
    print('5. Reports');
    print('0. Exit');

    final option = _readInteger('Select an option: ');

    try {
      switch (option) {
        case 1:
          _categoryMenu(categoryService, categoryProductService);
          break;

        case 2:
          _productMenu(productService, categoryProductService);
          break;

        case 3:
          _inventoryMenu(inventoryService, productService);
          break;

        case 4:
          _posMenu(saleService, productService);
          break;

        case 5:
          _reportsMenu(reportService);
          break;

        case 0:
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
          _viewCategoryProducts(categoryService, categoryProductService);
          break;

        case 9:
          _addProductToCategory(categoryProductService);
          break;

        case 10:
          _removeProductFromCategory(categoryProductService);
          break;

        case 0:
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
          _viewProductCategories(productService, categoryProductService);
          break;

        case 9:
          _addProductToCategory(categoryProductService);
          break;

        case 10:
          _removeProductFromCategory(categoryProductService);
          break;

        case 0:
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
      print('ERROR [${error.code}]: ${error.message}');
    } catch (error) {
      print('');
      print('UNEXPECTED ERROR: $error');
    }
  }
}

void _posMenu(SaleService saleService, ProductService productService) {
  while (true) {
    print('');
    print('========== POINT OF SALE ==========');
    print('1. New sale');
    print('2. Sales history');
    print('0. Back');

    final option = _readInteger('Select an option: ');

    try {
      switch (option) {
        case 1:
          _createSale(saleService, productService);
          break;

        case 2:
          _salesHistory(saleService, productService);
          break;

        case 0:
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

/*
------------------------------------------------------------
REPORTS
------------------------------------------------------------
*/

void _reportsMenu(ReportService reportService) {
  while (true) {
    print('');
    print('========== REPORTS ==========');
    print('1. Sales Summary');
    print('2. Sales History');
    print('3. Sale Details');
    print('4. Product Sales');
    print('5. Inventory Report');
    print('6. Low-Stock Report');
    print('0. Back');

    final option = _readInteger('Select an option: ');

    try {
      switch (option) {
        case 1:
          _salesSummaryReport(reportService);
          break;

        case 2:
          _salesHistoryReport(reportService);
          break;

        case 3:
          _saleDetailsReport(reportService);
          break;

        case 4:
          _productSalesReport(reportService);
          break;

        case 5:
          _inventoryReport(reportService);
          break;

        case 6:
          _lowStockReport(reportService);
          break;

        case 0:
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

void _salesSummaryReport(ReportService reportService) {
  final summary = reportService.getSalesSummary();

  print('');
  print('========== SALES SUMMARY ==========');
  print('');
  print('Number of sales: ${summary.numberOfSales}');
  print('Sales subtotal:  Le ${summary.salesSubtotal}');
  print('Tax collected:   Le ${summary.taxCollected}');
  print('Total collected: Le ${summary.totalCollected}');
  print('Average sale:    Le ${summary.averageSale}');
  print('');
}

void _salesHistoryReport(ReportService reportService) {
  final sales = reportService.getSalesHistory();

  print('');
  print('========== SALES HISTORY REPORT ==========');

  if (sales.isEmpty) {
    print('');
    print('No sales found.');
    return;
  }

  print('');

  for (final sale in sales) {
    print(
      'ID: ${sale.id} | '
      'Sale: ${sale.saleNumber}',
    );
    print('Date: ${sale.saleDate}');
    print(
      'Subtotal: Le ${sale.subtotal} | '
      'Tax: Le ${sale.taxAmount} | '
      'Total: Le ${sale.totalAmount}',
    );
    print('----------------------------------------');
  }
}

void _saleDetailsReport(ReportService reportService) {
  while (true) {
    print('');
    print('========== SALE DETAILS REPORT ==========');
    print('1. Find by Sale ID');
    print('2. Find by Sale Number');
    print('0. Back');

    final option = _readInteger('Select an option: ');

    if (option == 0) {
      return;
    }

    SaleDetailsReport report;

    switch (option) {
      case 1:
        final saleId = _readInteger('Sale ID: ');

        report = reportService.getSaleDetailsById(saleId);
        break;

      case 2:
        final saleNumber = _readText('Sale Number: ');

        report = reportService.getSaleDetailsByNumber(saleNumber);
        break;

      default:
        print('Invalid option.');
        continue;
    }

    _printSaleDetailsReport(report);
    return;
  }
}

void _printSaleDetailsReport(SaleDetailsReport report) {
  final sale = report.sale;

  print('');
  print('========================================');
  print('             SALE DETAILS');
  print('========================================');
  print('');
  print('Sale ID:     ${sale.id}');
  print('Sale Number: ${sale.saleNumber}');
  print('Date:        ${sale.saleDate}');
  print('');
  print('----------------------------------------');

  if (report.items.isEmpty) {
    print('No sale items found.');
  } else {
    for (final item in report.items) {
      print('Product: ${item.productName}');
      print('Product ID: ${item.productId}');
      print('Quantity: ${item.quantity}');
      print('Unit Price: Le ${item.unitPrice}');
      print('Cost Price: Le ${item.costPrice}');
      print('Subtotal: Le ${item.subtotal}');
      print('----------------------------------------');
    }
  }

  print('Subtotal: Le ${sale.subtotal}');
  print('Tax:      Le ${sale.taxAmount}');
  print('Total:    Le ${sale.totalAmount}');
  print('Payment:  Le ${sale.paymentAmount}');
  print('Change:   Le ${sale.changeAmount}');
  print('');
}

void _productSalesReport(ReportService reportService) {
  final reports = reportService.getProductSales();

  print('');
  print('========== PRODUCT SALES REPORT ==========');

  if (reports.isEmpty) {
    print('');
    print('No product sales found.');
    return;
  }

  print('');

  for (final report in reports) {
    print('Product: ${report.productName}');
    print('Product ID: ${report.productId}');
    print('Quantity sold: ${report.quantitySold}');
    print('Sales value: Le ${report.salesValue}');
    print('Cost value: Le ${report.costValue}');
    print('Gross profit: Le ${report.grossProfit}');
    print('----------------------------------------');
  }
}

void _inventoryReport(ReportService reportService) {
  final reports = reportService.getInventoryReport();

  print('');
  print('========== INVENTORY REPORT ==========');

  if (reports.isEmpty) {
    print('');
    print('No products found.');
    return;
  }

  print('');

  for (final report in reports) {
    final stockStatus = report.lowStock ? 'LOW STOCK' : 'OK';

    final productStatus = report.active ? 'ACTIVE' : 'INACTIVE';

    print('Product: ${report.productName}');
    print('Product ID: ${report.productId}');
    print('Quantity: ${report.quantity}');
    print('Reorder level: ${report.reorderLevel}');
    print('Stock status: $stockStatus');
    print('Product status: $productStatus');
    print('----------------------------------------');
  }
}

void _lowStockReport(ReportService reportService) {
  final products = reportService.getLowStockProducts();

  print('');
  print('========== LOW-STOCK REPORT ==========');

  if (products.isEmpty) {
    print('');
    print('No low-stock products.');
    return;
  }

  print('');

  final reports = reportService.getLowStockReport();

  for (final report in reports) {
    print('Product: ${report.productName}');
    print('Product ID: ${report.productId}');
    print('Current stock: ${report.quantity}');
    print('Reorder level: ${report.reorderLevel}');
    print('----------------------------------------');
  }
}

/*
------------------------------------------------------------
CATEGORIES
------------------------------------------------------------
*/

void _createCategory(CategoryService service) {
  print('');

  final name = _readText('Category name: ');

  final description = _readOptionalText('Description: ');

  final category = service.create(name: name, description: description);

  print('Category created successfully. ID: ${category.id}');
}

void _listCategories(CategoryService service) {
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

void _findCategory(CategoryService service) {
  final id = _readInteger('Category ID: ');

  final category = service.findById(id);

  if (category == null) {
    throw const NotFoundException(message: 'Category not found.');
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

void _searchCategories(CategoryService service) {
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

void _editCategory(CategoryService service) {
  final id = _readInteger('Category ID: ');

  final existing = service.findById(id);

  if (existing == null) {
    throw const NotFoundException(message: 'Category not found.');
  }

  print('Current name: ${existing.name}');

  final name = _readOptionalText('New name: ');

  print(
    'Current description: '
    '${existing.description ?? 'N/A'}',
  );

  final description = _readOptionalText('New description: ');

  final category = service.update(
    id: id,
    name: name == null || name.isEmpty ? existing.name : name,
    description: description ?? existing.description,
  );

  print('Category updated successfully. ID: ${category.id}');
}

void _activateCategory(CategoryService service) {
  final id = _readInteger('Category ID: ');

  service.activate(id);

  print('Category activated successfully.');
}

void _deactivateCategory(CategoryService service) {
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
    throw const NotFoundException(message: 'Category not found.');
  }

  final products = relationshipService.findProductsByCategory(categoryId);

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

void _addProductToCategory(CategoryProductService service) {
  final categoryId = _readInteger('Category ID: ');

  final productId = _readInteger('Product ID: ');

  service.assignProductToCategory(categoryId, productId);

  print('Product assigned to category successfully.');
}

void _removeProductFromCategory(CategoryProductService service) {
  final categoryId = _readInteger('Category ID: ');

  final productId = _readInteger('Product ID: ');

  service.removeProductFromCategory(categoryId, productId);

  print('Product removed from category successfully.');
}

/*
------------------------------------------------------------
PRODUCTS
------------------------------------------------------------
*/

void _createProduct(ProductService service) {
  print('');

  final name = _readText('Product name: ');

  final sku = _readOptionalText('SKU (optional): ');

  final unit = _readProductUnit();

  final costPrice = _readInteger('Cost price: ');

  final sellingPrice = _readInteger('Selling price: ');

  final reorderLevel = _readInteger('Reorder level: ');

  final product = service.create(
    name: name,
    sku: sku,
    unit: unit,
    costPrice: costPrice,
    sellingPrice: sellingPrice,
    reorderLevel: reorderLevel,
  );

  print('Product created successfully. ID: ${product.id}');
}

void _listProducts(ProductService service) {
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

void _findProduct(ProductService service) {
  final id = _readInteger('Product ID: ');

  final product = service.findById(id);

  if (product == null) {
    throw const NotFoundException(message: 'Product not found.');
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

void _searchProducts(ProductService service) {
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

void _editProduct(ProductService service) {
  final id = _readInteger('Product ID: ');

  final existing = service.findById(id);

  if (existing == null) {
    throw const NotFoundException(message: 'Product not found.');
  }

  print('Current name: ${existing.name}');

  final name = _readOptionalText('New name: ');

  print('Current SKU: ${existing.sku ?? 'N/A'}');

  final sku = _readOptionalText('New SKU: ');

  print('Current unit: ${existing.unit}');

  final unit = _readOptionalProductUnit(existing.unit);

  print(
    'Current cost price: '
    'Le ${existing.costPrice}',
  );

  final costPrice = _readOptionalInteger('New cost price: ');

  print(
    'Current selling price: '
    'Le ${existing.sellingPrice}',
  );

  final sellingPrice = _readOptionalInteger('New selling price: ');

  print(
    'Current reorder level: '
    '${existing.reorderLevel}',
  );

  final reorderLevel = _readOptionalInteger('New reorder level: ');

  final product = service.update(
    id: id,
    name: name == null || name.isEmpty ? existing.name : name,
    sku: sku == null
        ? existing.sku
        : sku.isEmpty
        ? null
        : sku,
    unit: unit,
    costPrice: costPrice ?? existing.costPrice,
    sellingPrice: sellingPrice ?? existing.sellingPrice,
    reorderLevel: reorderLevel ?? existing.reorderLevel,
  );

  print('Product updated successfully. ID: ${product.id}');
}

void _activateProduct(ProductService service) {
  final id = _readInteger('Product ID: ');

  service.activate(id);

  print('Product activated successfully.');
}

void _deactivateProduct(ProductService service) {
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
    throw const NotFoundException(message: 'Product not found.');
  }

  final categories = relationshipService.findCategoriesByProduct(productId);

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

/*
------------------------------------------------------------
INVENTORY
------------------------------------------------------------
*/

void _viewStock(InventoryService service) {
  final productId = _readInteger('Product ID: ');

  final inventory = service.getStock(productId);

  print(
    'Product ${inventory.productId}: '
    '${inventory.quantity} units',
  );
}

void _receiveStock(InventoryService service) {
  final productId = _readInteger('Product ID: ');

  final quantity = _readInteger('Quantity received: ');

  final reference = _readOptionalText('Reference (optional): ');

  service.receiveStock(productId, quantity, reference: reference);

  print('Stock received successfully.');
}

void _adjustStock(InventoryService service) {
  final productId = _readInteger('Product ID: ');

  final quantity = _readInteger('Adjustment quantity: ');

  final reference = _readOptionalText('Reference (optional): ');

  service.adjustStock(productId, quantity, reference: reference);

  print('Stock adjusted successfully.');
}

void _lowStockProducts(InventoryService service) {
  final products = service.findLowStockProducts();

  print('');

  if (products.isEmpty) {
    print('No low-stock products.');
    return;
  }

  print('Low-stock products:');

  for (final product in products) {
    final inventory = service.getStock(product.id!);

    print(
      '${product.id} | ${product.name} | '
      'Stock: ${inventory.quantity} | '
      'Reorder: ${product.reorderLevel}',
    );
  }
}

void _stockMovementHistory(InventoryService service) {
  final productId = _readInteger('Product ID: ');

  final movements = service.findMovements(productId);

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

/*
------------------------------------------------------------
POINT OF SALE
------------------------------------------------------------
*/

void _createSale(SaleService saleService, ProductService productService) {
  print('');
  print('========== NEW SALE ==========');

  final saleNumber = _generateSaleNumber(saleService);

  final cart = <SaleItemRequest>[];

  print('');
  print('Sale Number: $saleNumber');
  print('Sale number generated automatically.');

  while (true) {
    _printCart(
      cart,
      productService,
      saleNumber: saleNumber,
      taxRate: saleService.taxRate,
    );

    print('');
    print('========== SALE OPTIONS ==========');
    print('1. Add product');
    print('2. Change quantity');
    print('3. Remove item');
    print('4. Checkout');
    print('5. Cancel sale');

    final option = _readInteger('Select an option: ');

    switch (option) {
      case 1:
        _addProductToCart(cart, productService);
        break;

      case 2:
        _changeCartQuantity(cart);
        break;

      case 3:
        _removeCartItem(cart, productService);
        break;

      case 4:
        final completed = _checkoutSale(
          saleService,
          productService,
          saleNumber,
          cart,
        );

        if (completed) {
          return;
        }
        break;

      case 5:
        print('');
        print('Sale cancelled.');
        return;

      default:
        print('Invalid option.');
    }
  }
}

void _addProductToCart(
  List<SaleItemRequest> cart,
  ProductService productService,
) {
  print('');
  print('========== ADD PRODUCT ==========');
  print('Enter 0 as Product ID to return to cart.');

  final productId = _readInteger('Product ID: ');

  if (productId == 0) {
    return;
  }

  final product = productService.findById(productId);

  if (product == null) {
    print('Product not found.');
    return;
  }

  if (!product.active) {
    print('Product is inactive.');
    return;
  }

  print('');
  print('Product: ${product.name}');
  print('SKU: ${product.sku ?? 'N/A'}');
  print('Unit: ${product.unit}');
  print(
    'Selling price: '
    'Le ${product.sellingPrice}',
  );

  final quantity = _readPositiveInteger('Quantity: ');

  final existingIndex = cart.indexWhere((item) => item.productId == productId);

  if (existingIndex >= 0) {
    final existingItem = cart[existingIndex];

    final updatedQuantity = existingItem.quantity + quantity;

    cart[existingIndex] = SaleItemRequest(
      productId: productId,
      quantity: updatedQuantity,
    );

    print('');
    print(
      'Product quantity updated. '
      'Cart quantity: $updatedQuantity.',
    );
  } else {
    cart.add(SaleItemRequest(productId: productId, quantity: quantity));

    print('');
    print('Product added to cart.');
  }
}

void _printCart(
  List<SaleItemRequest> cart,
  ProductService productService, {
  String? saleNumber,
  double taxRate = 0.0,
}) {
  print('');
  print('========================================');
  print('                 CART');
  print('========================================');

  if (saleNumber != null) {
    print('Sale Number: $saleNumber');
    print('----------------------------------------');
  }

  if (cart.isEmpty) {
    print('Cart is empty.');
    print('========================================');
    return;
  }

  var subtotal = 0;

  for (var index = 0; index < cart.length; index++) {
    final item = cart[index];

    final product = productService.findById(item.productId);

    if (product == null) {
      print(
        '${index + 1}. Product ${item.productId} '
        '(no longer available)',
      );
      print('----------------------------------------');
      continue;
    }

    final itemSubtotal = product.sellingPrice * item.quantity;

    subtotal += itemSubtotal;

    print('${index + 1}. ${product.name}');
    print('   Unit: ${product.unit}');
    print('   Quantity: ${item.quantity}');
    print('   Price: Le ${product.sellingPrice}');
    print('   Subtotal: Le $itemSubtotal');
    print('----------------------------------------');
  }

  final tax = (subtotal * taxRate).round();

  final total = subtotal + tax;

  print('Subtotal: Le $subtotal');

  final taxPercent = (taxRate * 100).toStringAsFixed(0);

  print('Tax ($taxPercent%): Le $tax');

  print('Total: Le $total');
  print('========================================');
}

void _changeCartQuantity(List<SaleItemRequest> cart) {
  if (cart.isEmpty) {
    print('');
    print('Cart is empty.');
    return;
  }

  print('');
  print('========== CHANGE QUANTITY ==========');
  print('Enter 0 to return to cart.');

  final itemNumber = _readInteger('Cart item number: ');

  if (itemNumber == 0) {
    return;
  }

  final index = itemNumber - 1;

  if (index < 0 || index >= cart.length) {
    print('Invalid cart item.');
    return;
  }

  final currentItem = cart[index];

  print(
    'Current quantity: '
    '${currentItem.quantity}',
  );

  final quantity = _readPositiveInteger('New quantity: ');

  cart[index] = SaleItemRequest(
    productId: currentItem.productId,
    quantity: quantity,
  );

  print('Cart quantity updated.');
}

void _removeCartItem(
  List<SaleItemRequest> cart,
  ProductService productService,
) {
  if (cart.isEmpty) {
    print('');
    print('Cart is empty.');
    return;
  }

  print('');
  print('========== REMOVE ITEM ==========');
  print('Enter 0 to return to cart.');

  final itemNumber = _readInteger('Cart item number: ');

  if (itemNumber == 0) {
    return;
  }

  final index = itemNumber - 1;

  if (index < 0 || index >= cart.length) {
    print('Invalid cart item.');
    return;
  }

  final removedItem = cart.removeAt(index);

  final product = productService.findById(removedItem.productId);

  if (product != null) {
    print('${product.name} removed from cart.');
  } else {
    print('Item removed from cart.');
  }
}

bool _checkoutSale(
  SaleService saleService,
  ProductService productService,
  String saleNumber,
  List<SaleItemRequest> cart,
) {
  if (cart.isEmpty) {
    print('');
    print('Cannot checkout an empty cart.');
    return false;
  }

  while (true) {
    print('');
    print('========== CHECKOUT ==========');

    _printCart(
      cart,
      productService,
      saleNumber: saleNumber,
      taxRate: saleService.taxRate,
    );

    print('');
    print('1. Confirm and pay');
    print('2. Return to cart');
    print('3. Cancel sale');

    final option = _readInteger('Select an option: ');

    switch (option) {
      case 1:
        final paymentAmount = _readInteger('Payment amount: ');

        try {
          final sale = saleService.completeSale(
            saleNumber: saleNumber,
            items: List<SaleItemRequest>.from(cart),
            paymentAmount: paymentAmount,
          );

          print('');
          print('========================================');
          print('              SALE RECEIPT');
          print('========================================');
          print('Sale Number: ${sale.saleNumber}');
          print('Date: ${sale.saleDate}');
          print('----------------------------------------');

          _printReceiptItems(cart, productService);

          print('----------------------------------------');
          print('Subtotal:    Le ${sale.subtotal}');
          print('Tax:         Le ${sale.taxAmount}');
          print('Total:       Le ${sale.totalAmount}');
          print('Payment:     Le ${sale.paymentAmount}');
          print('Change:      Le ${sale.changeAmount}');
          print('----------------------------------------');
          print('Sale completed successfully.');
          print('========================================');

          return true;
        } on ShopFlowException catch (error) {
          print('');
          print(
            'ERROR [${error.code}]: '
            '${error.message}',
          );
          print('');
          print('The sale was not completed.');
          print('Your cart has been kept.');

          while (true) {
            print('');
            print('1. Return to cart');
            print('2. Cancel sale');

            final recoveryOption = _readInteger('Select an option: ');

            switch (recoveryOption) {
              case 1:
                return false;

              case 2:
                print('');
                print('Sale cancelled.');
                return true;

              default:
                print('Invalid option.');
            }
          }
        }

      case 2:
        return false;

      case 3:
        print('');
        print('Sale cancelled.');
        return true;

      default:
        print('Invalid option.');
    }
  }
}

void _printReceiptItems(
  List<SaleItemRequest> cart,
  ProductService productService,
) {
  for (final item in cart) {
    final product = productService.findById(item.productId);

    if (product == null) {
      continue;
    }

    final subtotal = product.sellingPrice * item.quantity;

    print(
      '${product.name} | '
      '${item.quantity} x '
      'Le ${product.sellingPrice} | '
      'Le $subtotal',
    );
  }
}

String _generateSaleNumber(SaleService service) {
  final sales = service.findAll();

  var nextNumber = 1;

  for (final sale in sales) {
    final id = sale.id;

    if (id != null && id >= nextNumber) {
      nextNumber = id + 1;
    }
  }

  return 'S${nextNumber.toString().padLeft(3, '0')}';
}

void _salesHistory(SaleService saleService, ProductService productService) {
  while (true) {
    final sales = saleService.findAll();

    print('');
    print('========== SALES HISTORY ==========');

    if (sales.isEmpty) {
      print('No sales found.');
      return;
    }

    for (final sale in sales) {
      print(
        '${sale.id} | '
        '${sale.saleNumber} | '
        'Total: Le ${sale.totalAmount} | '
        '${sale.saleDate}',
      );
    }

    print('');
    print('Enter Sale ID to view details.');
    print('0. Back');

    final saleId = _readInteger('Sale ID: ');

    if (saleId == 0) {
      return;
    }

    _viewSaleDetails(saleService, productService, saleId);
  }
}

void _viewSaleDetails(
  SaleService saleService,
  ProductService productService,
  int saleId,
) {
  final sale = saleService.findById(saleId);

  if (sale == null) {
    print('');
    print('Sale not found.');
    return;
  }

  final items = saleService.findItems(saleId);

  print('');
  print('========== SALE DETAILS ==========');
  print('');
  print('Sale Number: ${sale.saleNumber}');
  print('Date: ${sale.saleDate}');
  print('');
  print('----------------------------------------');

  if (items.isEmpty) {
    print('No sale items found.');
  } else {
    for (final item in items) {
      final product = productService.findById(item.productId);

      print(
        'Product: '
        '${product?.name ?? 'Unknown product'}',
      );
      print('Quantity: ${item.quantity}');
      print('Unit Price: Le ${item.unitPrice}');
      print('Subtotal: Le ${item.subtotal}');
      print('----------------------------------------');
    }
  }

  print('Subtotal: Le ${sale.subtotal}');
  print('Tax:      Le ${sale.taxAmount}');
  print('Total:    Le ${sale.totalAmount}');
  print('Payment:  Le ${sale.paymentAmount}');
  print('Change:   Le ${sale.changeAmount}');

  print('');
  print('0. Back');

  while (true) {
    final option = _readInteger('Select an option: ');

    if (option == 0) {
      return;
    }

    print('Invalid option.');
  }
}

/*
------------------------------------------------------------
INPUT HELPERS
------------------------------------------------------------
*/

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

    if (choice != null && choice >= 1 && choice <= units.length) {
      return units[choice - 1];
    }

    print('Please enter a valid whole number.');
    print('Select unit: ');
  }
}

ProductUnit _readOptionalProductUnit(ProductUnit current) {
  print('');
  print('Available units:');

  final units = ProductUnit.values;

  for (var i = 0; i < units.length; i++) {
    print('${i + 1}. ${units[i]}');
  }

  print('Press Enter to keep ${current.label}.');

  while (true) {
    final input = stdin.readLineSync()?.trim() ?? '';

    if (input.isEmpty) {
      return current;
    }

    final choice = int.tryParse(input);

    if (choice != null && choice >= 1 && choice <= units.length) {
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

int _readPositiveInteger(String prompt) {
  while (true) {
    final value = _readInteger(prompt);

    if (value > 0) {
      return value;
    }

    print('Value must be greater than zero.');
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
