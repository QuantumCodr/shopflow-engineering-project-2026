/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Inventory Report Model
Description  : Represents current inventory information
               for a product.
------------------------------------------------------------
*/

class InventoryReport {
  final int productId;
  final String productName;
  final int quantity;
  final int reorderLevel;
  final bool lowStock;
  final bool active;

  const InventoryReport({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.reorderLevel,
    required this.lowStock,
    required this.active,
  });
}