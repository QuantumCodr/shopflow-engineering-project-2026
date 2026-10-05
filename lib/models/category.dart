/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Category Model
Description  : Represents a product category in ShopFlow.
------------------------------------------------------------
*/

class Category {
  final int? id;
  final String name;
  final String? description;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    this.id,
    required this.name,
    this.description,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
  });
}