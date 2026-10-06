/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Sale Item Repository
Description  : Provides SQLite persistence for sale items.
------------------------------------------------------------
*/

import 'package:sqlite3/sqlite3.dart';

import '../core/errors/shopflow_exception.dart';
import '../models/sale_item.dart';

abstract interface class SaleItemRepository {
  SaleItem create(SaleItem item);

  List<SaleItem> findBySaleId(int saleId);
}

class SqliteSaleItemRepository implements SaleItemRepository {
  final Database database;

  SqliteSaleItemRepository(this.database);

  @override
  SaleItem create(SaleItem item) {
    try {
      database.execute(
        '''
        INSERT INTO sale_items (
          sale_id,
          product_id,
          quantity,
          unit_price,
          cost_price,
          subtotal
        )
        VALUES (?, ?, ?, ?, ?, ?)
        ''',
        [
          item.saleId,
          item.productId,
          item.quantity,
          item.unitPrice,
          item.costPrice,
          item.subtotal,
        ],
      );

      return SaleItem(
        id: database.lastInsertRowId,
        saleId: item.saleId,
        productId: item.productId,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        costPrice: item.costPrice,
        subtotal: item.subtotal,
      );
    } on SqliteException catch (error) {
      throw PersistenceException(
        message: 'Failed to create sale item.',
        cause: error,
      );
    }
  }

  @override
  List<SaleItem> findBySaleId(int saleId) {
    try {
      final rows = database.select(
        '''
        SELECT *
        FROM sale_items
        WHERE sale_id = ?
        ORDER BY id
        ''',
        [saleId],
      );

      return rows.map(_fromRow).toList();
    } on SqliteException catch (error) {
      throw PersistenceException(
        message: 'Failed to retrieve sale items.',
        cause: error,
      );
    }
  }

  SaleItem _fromRow(Row row) {
    return SaleItem(
      id: row['id'] as int,
      saleId: row['sale_id'] as int,
      productId: row['product_id'] as int,
      quantity: row['quantity'] as int,
      unitPrice: row['unit_price'] as int,
      costPrice: row['cost_price'] as int,
      subtotal: row['subtotal'] as int,
    );
  }
}