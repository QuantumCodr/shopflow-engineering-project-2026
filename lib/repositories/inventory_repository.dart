/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Inventory Repository
Description  : Provides SQLite persistence for inventory.
------------------------------------------------------------
*/

import 'package:sqlite3/sqlite3.dart';

import '../core/errors/shopflow_exception.dart';
import '../enums/stock_movement_type.dart';
import '../models/inventory.dart';
import '../models/stock_movement.dart';

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

  void sellStock(
    int productId,
    int quantity, {
    String? reference,
  });

  List<StockMovement> findMovementsByProduct(
    int productId,
  );
}

class SqliteInventoryRepository
    implements InventoryRepository {
  final Database database;

  SqliteInventoryRepository(this.database);

  @override
  Inventory getByProductId(int productId) {
    try {
      final rows = database.select(
        '''
        SELECT *
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
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to retrieve inventory.',
        cause: error,
      );
    }
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
      StockMovementType.receipt,
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
      StockMovementType.adjustment,
      reference,
    );
  }

  @override
  void sellStock(
    int productId,
    int quantity, {
    String? reference,
  }) {
    _changeStock(
      productId,
      -quantity,
      StockMovementType.sale,
      reference,
    );
  }

  @override
  List<StockMovement> findMovementsByProduct(
    int productId,
  ) {
    try {
      final rows = database.select(
        '''
        SELECT *
        FROM stock_movements
        WHERE product_id = ?
        ORDER BY created_at DESC, id DESC
        ''',
        [productId],
      );

      return rows.map(_movementFromRow).toList();
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to retrieve stock movements.',
        cause: error,
      );
    }
  }

  void _changeStock(
    int productId,
    int quantity,
    StockMovementType movementType,
    String? reference,
  ) {
    try {
      database.execute(
        '''
        INSERT OR IGNORE INTO inventory (
          product_id,
          quantity
        )
        VALUES (?, 0)
        ''',
        [productId],
      );

      database.execute(
        '''
        UPDATE inventory
        SET quantity = quantity + ?
        WHERE product_id = ?
        ''',
        [
          quantity,
          productId,
        ],
      );

      database.execute(
        '''
        INSERT INTO stock_movements (
          product_id,
          movement_type,
          quantity,
          reference,
          created_at
        )
        VALUES (?, ?, ?, ?, ?)
        ''',
        [
          productId,
          movementType.value,
          quantity,
          reference,
          DateTime.now().toUtc().toIso8601String(),
        ],
      );
    } catch (error) {
      if (error is ShopFlowException) {
        rethrow;
      }

      throw PersistenceException(
        message: 'Failed to update inventory.',
        cause: error,
      );
    }
  }

  StockMovement _movementFromRow(Row row) {
    return StockMovement(
      id: row['id'] as int,
      productId: row['product_id'] as int,
      movementType: StockMovementType.fromValue(
        row['movement_type'] as String,
      ),
      quantity: row['quantity'] as int,
      reference: row['reference'] as String?,
      createdAt: DateTime.parse(
        row['created_at'] as String,
      ),
    );
  }
}