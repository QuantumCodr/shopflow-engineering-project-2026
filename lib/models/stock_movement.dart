/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Stock Movement Model
Description  : Represents an inventory movement.
------------------------------------------------------------
*/

import '../enums/stock_movement_type.dart';

class StockMovement {
  final int? id;
  final int productId;
  final StockMovementType movementType;
  final int quantity;
  final String? reference;
  final DateTime createdAt;

  StockMovement({
    this.id,
    required this.productId,
    required this.movementType,
    required this.quantity,
    this.reference,
    required this.createdAt,
  });
}