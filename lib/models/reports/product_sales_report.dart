/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Product Sales Report Model
Description  : Represents aggregated sales information
               for a product.
------------------------------------------------------------
*/

class ProductSalesReport {
  final int productId;
  final String productName;
  final int quantitySold;
  final int salesValue;
  final int costValue;
  final int grossProfit;

  const ProductSalesReport({
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.salesValue,
    required this.costValue,
    required this.grossProfit,
  });
}