/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Sale Service
Description  : Contains sales and POS business rules.
------------------------------------------------------------
*/

import '../core/errors/shopflow_exception.dart';
import '../database/database.dart';
import '../models/sale.dart';
import '../models/sale_item.dart';
import '../repositories/inventory_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/sale_item_repository.dart';
import '../repositories/sale_repository.dart';

class SaleService {
  final SaleRepository saleRepository;
  final SaleItemRepository saleItemRepository;
  final ProductRepository productRepository;
  final InventoryRepository inventoryRepository;
  final ShopFlowDatabase database;
  final double taxRate;

  SaleService(
    this.saleRepository,
    this.saleItemRepository,
    this.productRepository,
    this.inventoryRepository,
    this.database, {
    this.taxRate = 0.0,
  }) {
    if (taxRate < 0) {
      throw const ValidationException(
        message: 'Tax rate cannot be negative.',
      );
    }
  }

  Sale completeSale({
    required String saleNumber,
    required List<SaleItemRequest> items,
    required int paymentAmount,
  }) {
    final cleanSaleNumber = saleNumber.trim();

    if (cleanSaleNumber.isEmpty) {
      throw const ValidationException(
        message: 'Sale number cannot be empty.',
      );
    }

    if (items.isEmpty) {
      throw const ValidationException(
        message: 'A sale must contain at least one item.',
      );
    }

    if (paymentAmount < 0) {
      throw const ValidationException(
        message: 'Payment amount cannot be negative.',
      );
    }

    final preparedItems = _prepareItems(items);
    final subtotal = _calculateSubtotal(preparedItems);
    final taxAmount = _calculateTax(subtotal);
    final totalAmount = subtotal + taxAmount;

    if (paymentAmount < totalAmount) {
      throw const BusinessRuleException(
        message: 'Payment amount is less than the sale total.',
      );
    }

    final changeAmount = paymentAmount - totalAmount;

    final existingSale = saleRepository.findBySaleNumber(
      cleanSaleNumber,
    );

    if (existingSale != null) {
      throw const ConflictException(
        message: 'Sale number already exists.',
      );
    }

    final sale = Sale(
      saleNumber: cleanSaleNumber,
      saleDate: DateTime.now().toUtc(),
      subtotal: subtotal,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      paymentAmount: paymentAmount,
      changeAmount: changeAmount,
    );

    return database.transaction(() {
      final createdSale = saleRepository.create(sale);

      for (final item in preparedItems) {
        final saleItem = SaleItem(
          saleId: createdSale.id!,
          productId: item.productId,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          costPrice: item.costPrice,
          subtotal: item.subtotal,
        );

        saleItemRepository.create(saleItem);

        inventoryRepository.sellStock(
          item.productId,
          item.quantity,
          reference: cleanSaleNumber,
        );
      }

      return createdSale;
    });
  }

  Sale? findById(int id) {
    return saleRepository.findById(id);
  }

  Sale? findBySaleNumber(String saleNumber) {
    final cleanSaleNumber = saleNumber.trim();

    if (cleanSaleNumber.isEmpty) {
      throw const ValidationException(
        message: 'Sale number cannot be empty.',
      );
    }

    return saleRepository.findBySaleNumber(
      cleanSaleNumber,
    );
  }

  List<Sale> findAll() {
    return saleRepository.findAll();
  }

  List<SaleItem> findItems(int saleId) {
    if (saleId <= 0) {
      throw const ValidationException(
        message: 'Sale ID must be greater than zero.',
      );
    }

    final sale = saleRepository.findById(saleId);

    if (sale == null) {
      throw const NotFoundException(
        message: 'Sale not found.',
      );
    }

    return saleItemRepository.findBySaleId(saleId);
  }

  List<_PreparedSaleItem> _prepareItems(
    List<SaleItemRequest> items,
  ) {
    final requestedQuantities = <int, int>{};

    for (final item in items) {
      if (item.productId <= 0) {
        throw const ValidationException(
          message: 'Product ID must be greater than zero.',
        );
      }

      if (item.quantity <= 0) {
        throw const ValidationException(
          message: 'Sale quantity must be greater than zero.',
        );
      }

      requestedQuantities[item.productId] =
          (requestedQuantities[item.productId] ?? 0) + item.quantity;
    }

    final preparedItems = <_PreparedSaleItem>[];

    for (final entry in requestedQuantities.entries) {
      final productId = entry.key;
      final requestedQuantity = entry.value;

      final product = productRepository.findById(
        productId,
      );

      if (product == null) {
        throw const NotFoundException(
          message: 'Product not found.',
        );
      }

      if (!product.active) {
        throw const BusinessRuleException(
          message: 'Cannot sell an inactive product.',
        );
      }

      final inventory = inventoryRepository.getByProductId(
        productId,
      );

      if (inventory.quantity < requestedQuantity) {
        throw const BusinessRuleException(
          message: 'Insufficient stock for product.',
        );
      }

      preparedItems.add(
        _PreparedSaleItem(
          productId: product.id!,
          quantity: requestedQuantity,
          unitPrice: product.sellingPrice,
          costPrice: product.costPrice,
          subtotal: product.sellingPrice * requestedQuantity,
        ),
      );
    }

    return preparedItems;
  }

  int _calculateSubtotal(
    List<_PreparedSaleItem> items,
  ) {
    return items.fold(
      0,
      (total, item) => total + item.subtotal,
    );
  }

  int _calculateTax(int subtotal) {
    return (subtotal * taxRate).round();
  }
}

class SaleItemRequest {
  final int productId;
  final int quantity;

  const SaleItemRequest({
    required this.productId,
    required this.quantity,
  });
}

class _PreparedSaleItem {
  final int productId;
  final int quantity;
  final int unitPrice;
  final int costPrice;
  final int subtotal;

  const _PreparedSaleItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.costPrice,
    required this.subtotal,
  });
}