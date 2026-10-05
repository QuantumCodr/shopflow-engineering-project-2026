/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Stock Movement Type Enum
Description  : Defines the controlled types of inventory
               movements supported by ShopFlow.
------------------------------------------------------------
*/

enum StockMovementType {
  receipt('RECEIPT', 'Receipt'),
  sale('SALE', 'Sale'),
  adjustment('ADJUSTMENT', 'Adjustment'),
  returnMovement('RETURN', 'Return');

  final String value;
  final String label;

  const StockMovementType(this.value, this.label);

  static StockMovementType fromValue(String value) {
    for (final type in StockMovementType.values) {
      if (type.value == value) {
        return type;
      }
    }

    throw ArgumentError(
      'Unknown stock movement type: $value',
    );
  }

  @override
  String toString() {
    return label;
  }
}