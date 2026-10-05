/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Inventory Model
Description  : Represents the current stock quantity of a
               ShopFlow product.
------------------------------------------------------------
*/

class Inventory {
  final int productId;
  final int quantity;

  Inventory({
    required this.productId,
    required this.quantity,
  });
}