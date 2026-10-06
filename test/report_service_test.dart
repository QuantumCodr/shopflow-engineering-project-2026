/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Report Service Tests
Description  : Tests ShopFlow reporting business logic.
------------------------------------------------------------
*/

import 'package:test/test.dart';

import 'package:shopflow/core/errors/shopflow_exception.dart';
import 'package:shopflow/database/database.dart';
import 'package:shopflow/enums/product_unit.dart';
import 'package:shopflow/repositories/category_repository.dart';
import 'package:shopflow/repositories/inventory_repository.dart';
import 'package:shopflow/repositories/product_repository.dart';
import 'package:shopflow/repositories/sale_item_repository.dart';
import 'package:shopflow/repositories/sale_repository.dart';
import 'package:shopflow/services/inventory_service.dart';
import 'package:shopflow/services/product_service.dart';
import 'package:shopflow/services/report_service.dart';
import 'package:shopflow/services/sale_service.dart';

void main() {
  late ShopFlowDatabase database;
  late ProductService productService;
  late InventoryService inventoryService;
  late SaleService saleService;
  late ReportService reportService;

  setUp(() {
    database = ShopFlowDatabase(
      path: ':memory:',
    );

    final categoryRepository = SqliteCategoryRepository(
      database.database,
    );

    final productRepository = SqliteProductRepository(
      database.database,
    );

    final inventoryRepository = SqliteInventoryRepository(
      database.database,
    );

    final saleRepository = SqliteSaleRepository(
      database.database,
    );

    final saleItemRepository = SqliteSaleItemRepository(
      database.database,
    );

    productService = ProductService(
      productRepository,
      categoryRepository,
    );

    inventoryService = InventoryService(
      inventoryRepository,
      productRepository,
      database,
    );

    saleService = SaleService(
      saleRepository,
      saleItemRepository,
      productRepository,
      inventoryRepository,
      database,
      taxRate: 0.10,
    );

    reportService = ReportService(
      saleService,
      productService,
      inventoryService,
    );
  });

  tearDown(() {
    database.close();
  });

  test('returns empty sales summary when there are no sales', () {
    final summary = reportService.getSalesSummary();

    expect(summary.numberOfSales, 0);
    expect(summary.salesSubtotal, 0);
    expect(summary.taxCollected, 0);
    expect(summary.totalCollected, 0);
    expect(summary.averageSale, 0);
  });

  test('returns sales summary', () {
    final product = productService.create(
      name: 'Palm Oil',
      sku: 'PALM-001',
      unit: ProductUnit.oneGallon,
      costPrice: 150,
      sellingPrice: 200,
    );

    inventoryService.receiveStock(
      product.id!,
      10,
    );

    saleService.completeSale(
      saleNumber: 'S001',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 2,
        ),
      ],
      paymentAmount: 500,
    );

    final summary = reportService.getSalesSummary();

    expect(summary.numberOfSales, 1);
    expect(summary.salesSubtotal, 400);
    expect(summary.taxCollected, 40);
    expect(summary.totalCollected, 440);
    expect(summary.averageSale, 440);
  });

  test('returns sales history', () {
    final product = productService.create(
      name: 'Sugar',
      sku: 'SUGAR-001',
      unit: ProductUnit.bag,
      costPrice: 100,
      sellingPrice: 150,
    );

    inventoryService.receiveStock(
      product.id!,
      10,
    );

    saleService.completeSale(
      saleNumber: 'S001',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 1,
        ),
      ],
      paymentAmount: 200,
    );

    final history = reportService.getSalesHistory();

    expect(history.length, 1);
    expect(history.first.saleNumber, 'S001');
    expect(history.first.totalAmount, 165);
  });

  test('returns sale details with product information', () {
    final product = productService.create(
      name: 'Rice',
      sku: 'RICE-001',
      unit: ProductUnit.bag,
      costPrice: 400,
      sellingPrice: 500,
    );

    inventoryService.receiveStock(
      product.id!,
      10,
    );

    saleService.completeSale(
      saleNumber: 'S001',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 2,
        ),
      ],
      paymentAmount: 1100,
    );

    final details = reportService.getSaleDetailsByNumber(
      'S001',
    );

    expect(details.sale.saleNumber, 'S001');
    expect(details.items.length, 1);
    expect(details.items.first.productName, 'Rice');
    expect(details.items.first.quantity, 2);
    expect(details.items.first.unitPrice, 500);
    expect(details.items.first.costPrice, 400);
    expect(details.items.first.subtotal, 1000);
  });

  test('returns product sales report using historical sale cost', () {
    final product = productService.create(
      name: 'Onga',
      sku: 'ONGA-001',
      unit: ProductUnit.pack,
      costPrice: 100,
      sellingPrice: 150,
    );

    inventoryService.receiveStock(
      product.id!,
      10,
    );

    saleService.completeSale(
      saleNumber: 'S001',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 3,
        ),
      ],
      paymentAmount: 500,
    );

    final report = reportService.getProductSales();

    expect(report.length, 1);
    expect(report.first.productName, 'Onga');
    expect(report.first.quantitySold, 3);
    expect(report.first.salesValue, 450);
    expect(report.first.costValue, 300);
    expect(report.first.grossProfit, 150);
  });

  test('returns inventory report', () {
    final product = productService.create(
      name: 'Maggi',
      sku: 'MAGGI-001',
      unit: ProductUnit.pack,
      costPrice: 50,
      sellingPrice: 75,
      reorderLevel: 5,
    );

    inventoryService.receiveStock(
      product.id!,
      3,
    );

    final report = reportService.getInventoryReport();

    expect(report.length, 1);
    expect(report.first.productName, 'Maggi');
    expect(report.first.quantity, 3);
    expect(report.first.reorderLevel, 5);
    expect(report.first.lowStock, isTrue);
    expect(report.first.active, isTrue);
  });

  test('returns low-stock products', () {
    final product = productService.create(
      name: 'Benny',
      sku: 'BENNY-001',
      unit: ProductUnit.pack,
      costPrice: 50,
      sellingPrice: 75,
      reorderLevel: 5,
    );

    inventoryService.receiveStock(
      product.id!,
      2,
    );

    final products = reportService.getLowStockProducts();

    expect(products.length, 1);
    expect(products.first.id, product.id);
    expect(products.first.name, 'Benny');
  });

  test('throws when requested sale details do not exist', () {
    expect(
      () => reportService.getSaleDetailsById(999),
      throwsA(isA<NotFoundException>()),
    );
  });
}