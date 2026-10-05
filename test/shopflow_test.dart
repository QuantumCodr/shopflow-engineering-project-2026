/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Error Foundation Tests
Description  : Verifies the standard ShopFlow exception
               hierarchy and error codes.
------------------------------------------------------------
*/

import 'package:shopflow/shopflow.dart';
import 'package:test/test.dart';

void main() {
  group('ShopFlowException', () {
    test('ValidationException has the correct code', () {
      const error = ValidationException(
        message: 'Invalid product name.',
      );

      expect(error.code, equals('VALIDATION_ERROR'));
      expect(error.message, equals('Invalid product name.'));
      expect(error.toString(), equals('Invalid product name.'));
    });

    test('NotFoundException has the correct code', () {
      const error = NotFoundException(
        message: 'Product not found.',
      );

      expect(error.code, equals('NOT_FOUND'));
      expect(error.message, equals('Product not found.'));
    });

    test('ConflictException has the correct code', () {
      const error = ConflictException(
        message: 'SKU already exists.',
      );

      expect(error.code, equals('CONFLICT'));
      expect(error.message, equals('SKU already exists.'));
    });

    test('BusinessRuleException has the correct code', () {
      const error = BusinessRuleException(
        message: 'Inventory cannot become negative.',
      );

      expect(error.code, equals('BUSINESS_RULE_ERROR'));
      expect(error.message, equals('Inventory cannot become negative.'));
    });

    test('PersistenceException has the correct code', () {
      const cause = 'SQLite failure';

      const error = PersistenceException(
        message: 'Unable to save product.',
        cause: cause,
      );

      expect(error.code, equals('PERSISTENCE_ERROR'));
      expect(error.message, equals('Unable to save product.'));
      expect(error.cause, equals(cause));
    });
  });
}