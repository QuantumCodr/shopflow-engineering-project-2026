/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Product Unit Enum
Description  : Defines the controlled units that can be used
               when selling and managing ShopFlow products.
------------------------------------------------------------
*/

enum ProductUnit {
  unknown('UNKNOWN', 'Unknown'),
  piece('PIECE', 'Piece'),
  pack('PACK', 'Pack'),
  box('BOX', 'Box'),
  bag('BAG', 'Bag'),
  bottle('BOTTLE', 'Bottle'),
  carton('CARTON', 'Carton'),
  dozen('DOZEN', 'Dozen'),
  gram('GRAM', 'Gram'),
  kilogram('KILOGRAM', 'Kilogram'),
  milliliter('MILLILITER', 'Milliliter'),
  liter('LITER', 'Liter'),
  gallon('GALLON', 'Gallon'),
  oneGallon('ONE_GALLON', '1 Gallon');

  final String value;
  final String label;

  const ProductUnit(this.value, this.label);

  static ProductUnit fromValue(String value) {
    for (final unit in ProductUnit.values) {
      if (unit.value == value) {
        return unit;
      }
    }

    return ProductUnit.unknown;
  }

  @override
  String toString() {
    return label;
  }
}