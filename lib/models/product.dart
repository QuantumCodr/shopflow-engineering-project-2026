/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Product Model
Description  : Represents a product managed by ShopFlow.
------------------------------------------------------------
*/

import '../enums/product_unit.dart';

class Product {
  final int? id;
  final String name;
  final String? sku;
  final ProductUnit unit;
  final int costPrice;
  final int sellingPrice;
  final int reorderLevel;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    this.id,
    required this.name,
    this.sku,
    this.unit = ProductUnit.unknown,
    required this.costPrice,
    required this.sellingPrice,
    this.reorderLevel = 0,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
  });
}