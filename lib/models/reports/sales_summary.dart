/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Sales Summary Report Model
Description  : Represents summarized sales information.
------------------------------------------------------------
*/

class SalesSummary {
  final int numberOfSales;
  final int salesSubtotal;
  final int taxCollected;
  final int totalCollected;
  final int averageSale;

  const SalesSummary({
    required this.numberOfSales,
    required this.salesSubtotal,
    required this.taxCollected,
    required this.totalCollected,
    required this.averageSale,
  });
}