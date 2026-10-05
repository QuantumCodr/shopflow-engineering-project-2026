/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Application Errors
Description  : Defines the standard application exceptions
               used throughout the ShopFlow system.
------------------------------------------------------------
*/

/// Base exception for all expected ShopFlow application errors.
///
/// Services and repositories should use the specialized
/// exception types below instead of throwing generic Dart
/// exceptions such as ArgumentError or StateError.
class ShopFlowException implements Exception {
  final String code;
  final String message;

  const ShopFlowException({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return message;
  }
}

/// The supplied data is invalid.
class ValidationException extends ShopFlowException {
  const ValidationException({
    required super.message,
  }) : super(
          code: 'VALIDATION_ERROR',
        );
}

/// The requested entity does not exist.
class NotFoundException extends ShopFlowException {
  const NotFoundException({
    required super.message,
  }) : super(
          code: 'NOT_FOUND',
        );
}

/// The operation conflicts with existing data.
class ConflictException extends ShopFlowException {
  const ConflictException({
    required super.message,
  }) : super(
          code: 'CONFLICT',
        );
}

/// The data may be valid, but the requested business
/// operation is not allowed.
class BusinessRuleException extends ShopFlowException {
  const BusinessRuleException({
    required super.message,
  }) : super(
          code: 'BUSINESS_RULE_ERROR',
        );
}

/// A persistence or database operation failed.
class PersistenceException extends ShopFlowException {
  final Object? cause;

  const PersistenceException({
    required super.message,
    this.cause,
  }) : super(
          code: 'PERSISTENCE_ERROR',
        );
}