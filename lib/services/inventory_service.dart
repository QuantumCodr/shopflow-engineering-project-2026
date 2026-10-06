/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Inventory Service
Description  : Contains inventory business rules.
------------------------------------------------------------
*/

import '../core/errors/shopflow_exception.dart';
import '../database/database.dart';
import '../models/inventory.dart';
import '../models/product.dart';
import '../models/stock_movement.dart';
import '../repositories/inventory_repository.dart';
import '../repositories/product_repository.dart';

class InventoryService {
  final InventoryRepository inventoryRepository;
  final ProductRepository productRepository;
  final ShopFlowDatabase database;

  InventoryService(
    this.inventoryRepository,
    this.productRepository,
    this.database,
  );

  Inventory getStock(int productId) {
    _requireProduct(productId);

    return inventoryRepository.getByProductId(productId);
  }

  void receiveStock(
    int productId,
    int quantity, {
    String? reference,
  }) {
    _requireProduct(productId);

    if (quantity <= 0) {
      throw const ValidationException(
        message: 'Received quantity must be greater than zero.',
      );
    }

    database.transaction(() {
      inventoryRepository.receiveStock(
        productId,
        quantity,
        reference: _cleanReference(reference),
      );
    });
  }

  void adjustStock(
    int productId,
    int quantity, {
    String? reference,
  }) {
    _requireProduct(productId);

    if (quantity == 0) {
      throw const ValidationException(
        message: 'Adjustment quantity cannot be zero.',
      );
    }

    final current = inventoryRepository.getByProductId(
      productId,
    );

    if (current.quantity + quantity < 0) {
      throw const BusinessRuleException(
        message: 'Inventory cannot become negative.',
      );
    }

    database.transaction(() {
      inventoryRepository.adjustStock(
        productId,
        quantity,
        reference: _cleanReference(reference),
      );
    });
  }

  bool isLowStock(int productId) {
    final product = _requireProduct(productId);
    final inventory = inventoryRepository.getByProductId(
      productId,
    );

    return inventory.quantity <= product.reorderLevel;
  }

  List<Product> findLowStockProducts() {
    return productRepository.findAll().where((product) {
      return isLowStock(product.id!);
    }).toList();
  }

  List<int> findLowStockProductIds() {
    return findLowStockProducts()
        .map((product) => product.id!)
        .toList();
  }

  List<StockMovement> findMovements(int productId) {
    _requireProduct(productId);

    return inventoryRepository.findMovementsByProduct(
      productId,
    );
  }

  Product _requireProduct(int productId) {
    final product = productRepository.findById(productId);

    if (product == null) {
      throw const NotFoundException(
        message: 'Product not found.',
      );
    }

    return product;
  }

  String? _cleanReference(String? reference) {
    final cleanReference = reference?.trim();

    if (cleanReference == null || cleanReference.isEmpty) {
      return null;
    }

    return cleanReference;
  }
}