/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Report Service
Description  : Contains business logic for ShopFlow
               reports. Reports are read-only and do not
               modify sales, products, or inventory.
------------------------------------------------------------
*/

import '../core/errors/shopflow_exception.dart';
import '../models/product.dart';
import '../models/reports/inventory_report.dart';
import '../models/reports/product_sales_report.dart';
import '../models/reports/sale_details_report.dart';
import '../models/reports/sales_summary.dart';
import '../models/sale.dart';
import '../services/inventory_service.dart';
import '../services/product_service.dart';
import '../services/sale_service.dart';

class ReportService {
  final SaleService saleService;
  final ProductService productService;
  final InventoryService inventoryService;

  ReportService(
    this.saleService,
    this.productService,
    this.inventoryService,
  );

  SalesSummary getSalesSummary() {
    final sales = saleService.findAll();

    if (sales.isEmpty) {
      return const SalesSummary(
        numberOfSales: 0,
        salesSubtotal: 0,
        taxCollected: 0,
        totalCollected: 0,
        averageSale: 0,
      );
    }

    final salesSubtotal = sales.fold(
      0,
      (total, sale) => total + sale.subtotal,
    );

    final taxCollected = sales.fold(
      0,
      (total, sale) => total + sale.taxAmount,
    );

    final totalCollected = sales.fold(
      0,
      (total, sale) => total + sale.totalAmount,
    );

    return SalesSummary(
      numberOfSales: sales.length,
      salesSubtotal: salesSubtotal,
      taxCollected: taxCollected,
      totalCollected: totalCollected,
      averageSale: totalCollected ~/ sales.length,
    );
  }

  List<Sale> getSalesHistory() {
    return saleService.findAll();
  }

  SaleDetailsReport getSaleDetailsById(int saleId) {
    final sale = saleService.findById(saleId);

    if (sale == null) {
      throw const NotFoundException(
        message: 'Sale not found.',
      );
    }

    return _buildSaleDetails(sale);
  }

  SaleDetailsReport getSaleDetailsByNumber(
    String saleNumber,
  ) {
    final cleanSaleNumber = saleNumber.trim();

    if (cleanSaleNumber.isEmpty) {
      throw const ValidationException(
        message: 'Sale number cannot be empty.',
      );
    }

    final sale = saleService.findBySaleNumber(
      cleanSaleNumber,
    );

    if (sale == null) {
      throw const NotFoundException(
        message: 'Sale not found.',
      );
    }

    return _buildSaleDetails(sale);
  }

  List<ProductSalesReport> getProductSales() {
    final sales = saleService.findAll();
    final totals = <int, _ProductSalesAccumulator>{};

    for (final sale in sales) {
      final items = saleService.findItems(sale.id!);

      for (final item in items) {
        final accumulator = totals.putIfAbsent(
          item.productId,
          () => _ProductSalesAccumulator(),
        );

        accumulator.quantitySold += item.quantity;
        accumulator.salesValue += item.subtotal;
        accumulator.costValue += item.costPrice * item.quantity;
      }
    }

    final reports = <ProductSalesReport>[];

    for (final entry in totals.entries) {
      final product = productService.findById(entry.key);

      if (product == null) {
        continue;
      }

      final accumulator = entry.value;

      reports.add(
        ProductSalesReport(
          productId: product.id!,
          productName: product.name,
          quantitySold: accumulator.quantitySold,
          salesValue: accumulator.salesValue,
          costValue: accumulator.costValue,
          grossProfit:
              accumulator.salesValue - accumulator.costValue,
        ),
      );
    }

    reports.sort(
      (first, second) =>
          second.salesValue.compareTo(first.salesValue),
    );

    return reports;
  }

  List<InventoryReport> getInventoryReport() {
    final products = productService.findAll();

    return products.map((product) {
      final inventory = inventoryService.getStock(
        product.id!,
      );

      return InventoryReport(
        productId: product.id!,
        productName: product.name,
        quantity: inventory.quantity,
        reorderLevel: product.reorderLevel,
        lowStock: inventory.quantity <= product.reorderLevel,
        active: product.active,
      );
    }).toList();
  }

  List<InventoryReport> getLowStockReport() {
    return getInventoryReport()
        .where((report) => report.lowStock)
        .toList();
  }

  List<Product> getLowStockProducts() {
    return inventoryService.findLowStockProducts();
  }

  SaleDetailsReport _buildSaleDetails(Sale sale) {
    final saleItems = saleService.findItems(
      sale.id!,
    );

    final items = saleItems.map((item) {
      final product = productService.findById(
        item.productId,
      );

      return SaleDetailLine(
        productId: item.productId,
        productName: product?.name ?? 'Unknown Product',
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        costPrice: item.costPrice,
        subtotal: item.subtotal,
      );
    }).toList();

    return SaleDetailsReport(
      sale: sale,
      items: items,
    );
  }
}

class _ProductSalesAccumulator {
  int quantitySold = 0;
  int salesValue = 0;
  int costValue = 0;
}