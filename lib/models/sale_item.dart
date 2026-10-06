/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Sale Item Model
Description  : Represents a product line within a sale.
------------------------------------------------------------
*/

class SaleItem {
  final int? id;
  final int saleId;
  final int productId;
  final int quantity;
  final int unitPrice;
  final int costPrice;
  final int subtotal;

  SaleItem({
    this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.costPrice,
    required this.subtotal,
  });
}