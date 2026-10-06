/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Sale Repository
Description  : Provides SQLite persistence for sales.
------------------------------------------------------------
*/

import 'package:sqlite3/sqlite3.dart';

import '../core/errors/shopflow_exception.dart';
import '../models/sale.dart';

abstract interface class SaleRepository {
  Sale create(Sale sale);

  Sale? findById(int id);

  Sale? findBySaleNumber(String saleNumber);

  List<Sale> findAll();
}

class SqliteSaleRepository implements SaleRepository {
  final Database database;

  SqliteSaleRepository(this.database);

  @override
  Sale create(Sale sale) {
    try {
      database.execute(
        '''
        INSERT INTO sales (
          sale_number,
          sale_date,
          subtotal,
          tax_amount,
          total_amount,
          payment_amount,
          change_amount
        )
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          sale.saleNumber,
          sale.saleDate.toUtc().toIso8601String(),
          sale.subtotal,
          sale.taxAmount,
          sale.totalAmount,
          sale.paymentAmount,
          sale.changeAmount,
        ],
      );

      return Sale(
        id: database.lastInsertRowId,
        saleNumber: sale.saleNumber,
        saleDate: sale.saleDate,
        subtotal: sale.subtotal,
        taxAmount: sale.taxAmount,
        totalAmount: sale.totalAmount,
        paymentAmount: sale.paymentAmount,
        changeAmount: sale.changeAmount,
      );
    } on SqliteException catch (error) {
      throw PersistenceException(
        message: 'Failed to create sale.',
        cause: error,
      );
    }
  }

  @override
  Sale? findById(int id) {
    try {
      final rows = database.select(
        '''
        SELECT *
        FROM sales
        WHERE id = ?
        LIMIT 1
        ''',
        [id],
      );

      if (rows.isEmpty) {
        return null;
      }

      return _fromRow(rows.first);
    } on SqliteException catch (error) {
      throw PersistenceException(
        message: 'Failed to find sale.',
        cause: error,
      );
    }
  }

  @override
  Sale? findBySaleNumber(String saleNumber) {
    try {
      final rows = database.select(
        '''
        SELECT *
        FROM sales
        WHERE sale_number = ?
        LIMIT 1
        ''',
        [saleNumber],
      );

      if (rows.isEmpty) {
        return null;
      }

      return _fromRow(rows.first);
    } on SqliteException catch (error) {
      throw PersistenceException(
        message: 'Failed to find sale by sale number.',
        cause: error,
      );
    }
  }

  @override
  List<Sale> findAll() {
    try {
      final rows = database.select(
        '''
        SELECT *
        FROM sales
        ORDER BY sale_date DESC, id DESC
        ''',
      );

      return rows.map(_fromRow).toList();
    } on SqliteException catch (error) {
      throw PersistenceException(
        message: 'Failed to retrieve sales.',
        cause: error,
      );
    }
  }

  Sale _fromRow(Row row) {
    return Sale(
      id: row['id'] as int,
      saleNumber: row['sale_number'] as String,
      saleDate: DateTime.parse(
        row['sale_date'] as String,
      ),
      subtotal: row['subtotal'] as int,
      taxAmount: row['tax_amount'] as int,
      totalAmount: row['total_amount'] as int,
      paymentAmount: row['payment_amount'] as int,
      changeAmount: row['change_amount'] as int,
    );
  }
}