/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Inventory Service
Description  : Contains inventory business rules and
               stock validation.
------------------------------------------------------------
*/

import '../models/inventory.dart';
import '../models/product.dart';
import '../repositories/inventory_repository.dart';
import '../repositories/product_repository.dart';

class InventoryService {
  final InventoryRepository inventoryRepository;
  final ProductRepository productRepository;

  InventoryService(
    this.inventoryRepository,
    this.productRepository,
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
      throw ArgumentError(
        'Received quantity must be greater than zero.',
      );
    }

    inventoryRepository.receiveStock(
      productId,
      quantity,
      reference: reference,
    );
  }

  void adjustStock(
    int productId,
    int quantity, {
    String? reference,
  }) {
    _requireProduct(productId);

    final current =
        inventoryRepository.getByProductId(productId);

    final resultingQuantity =
        current.quantity + quantity;

    if (resultingQuantity < 0) {
      throw StateError(
        'Inventory cannot become negative.',
      );
    }

    inventoryRepository.adjustStock(
      productId,
      quantity,
      reference: reference,
    );
  }

  bool isLowStock(int productId) {
    final product = _requireProduct(productId);

    final inventory =
        inventoryRepository.getByProductId(productId);

    return inventory.quantity <= product.reorderLevel;
  }

  List<int> findLowStockProductIds() {
    return productRepository
        .findAll()
        .where((product) {
          final inventory =
              inventoryRepository.getByProductId(product.id!);

          return inventory.quantity <= product.reorderLevel;
        })
        .map((product) => product.id!)
        .toList();
  }

  Product _requireProduct(int productId) {
    final product =
        productRepository.findById(productId);

    if (product == null) {
      throw StateError('Product not found.');
    }

    return product;
  }
}