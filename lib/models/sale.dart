/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Sale Model
Description  : Represents a completed sale in ShopFlow.
------------------------------------------------------------
*/

class Sale {
  final int? id;
  final String saleNumber;
  final DateTime saleDate;
  final int subtotal;
  final int taxAmount;
  final int totalAmount;
  final int paymentAmount;
  final int changeAmount;

  Sale({
    this.id,
    required this.saleNumber,
    required this.saleDate,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    required this.paymentAmount,
    required this.changeAmount,
  });
}