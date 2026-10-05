/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Inventory Repository
Description  : Provides SQLite persistence for inventory
               quantities and stock movements.
------------------------------------------------------------
*/

import 'package:sqlite3/sqlite3.dart';

import '../models/inventory.dart';

abstract interface class InventoryRepository {
  Inventory getByProductId(int productId);

  void receiveStock(
    int productId,
    int quantity, {
    String? reference,
  });

  void adjustStock(
    int productId,
    int quantity, {
    String? reference,
  });
}

class SqliteInventoryRepository implements InventoryRepository {
  final Database database;

  SqliteInventoryRepository(this.database);

  @override
  Inventory getByProductId(int productId) {
    final rows = database.select(
      '''
      SELECT product_id, quantity
      FROM inventory
      WHERE product_id = ?
      ''',
      [productId],
    );

    if (rows.isEmpty) {
      return Inventory(
        productId: productId,
        quantity: 0,
      );
    }

    return Inventory(
      productId: rows.first['product_id'] as int,
      quantity: rows.first['quantity'] as int,
    );
  }

  @override
  void receiveStock(
    int productId,
    int quantity, {
    String? reference,
  }) {
    _changeStock(
      productId,
      quantity,
      'RECEIPT',
      reference,
    );
  }

  @override
  void adjustStock(
    int productId,
    int quantity, {
    String? reference,
  }) {
    _changeStock(
      productId,
      quantity,
      'ADJUSTMENT',
      reference,
    );
  }

  void _changeStock(
    int productId,
    int quantity,
    String movementType,
    String? reference,
  ) {
    database.execute('''
      INSERT INTO inventory (
        product_id,
        quantity
      )
      VALUES (?, ?)
      ON CONFLICT(product_id)
      DO UPDATE SET quantity = quantity + excluded.quantity;
    ''', [
      productId,
      quantity,
    ]);

    database.execute('''
      INSERT INTO stock_movements (
        product_id,
        movement_type,
        quantity,
        reference,
        created_at
      )
      VALUES (?, ?, ?, ?, ?);
    ''', [
      productId,
      movementType,
      quantity,
      reference,
      DateTime.now().toUtc().toIso8601String(),
    ]);
  }
}