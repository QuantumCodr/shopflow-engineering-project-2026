/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Sale Details Report Model
Description  : Represents a sale together with its items.
------------------------------------------------------------
*/

import '../sale.dart';

class SaleDetailsReport {
  final Sale sale;
  final List<SaleDetailLine> items;

  const SaleDetailsReport({
    required this.sale,
    required this.items,
  });
}

class SaleDetailLine {
  final int productId;
  final String productName;
  final int quantity;
  final int unitPrice;
  final int costPrice;
  final int subtotal;

  const SaleDetailLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.costPrice,
    required this.subtotal,
  });
}