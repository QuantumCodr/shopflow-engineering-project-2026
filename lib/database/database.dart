/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Database Foundation
Description  : SQLite database initialization and schema
               management for the ShopFlow system.
------------------------------------------------------------
*/

import 'package:sqlite3/sqlite3.dart';

class ShopFlowDatabase {
  final Database database;

  ShopFlowDatabase({String path = 'shopflow.db'})
      : database = sqlite3.open(path) {
    _configure();
    _createTables();
  }

  void _configure() {
    database.execute('PRAGMA foreign_keys = ON;');
  }

  void _createTables() {
    database.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT,
        active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      );
    ''');

    database.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        sku TEXT UNIQUE,
        unit TEXT NOT NULL,
        cost_price INTEGER NOT NULL,
        selling_price INTEGER NOT NULL,
        reorder_level INTEGER NOT NULL DEFAULT 0,
        active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,

        FOREIGN KEY (category_id)
          REFERENCES categories(id)
      );
    ''');

    database.execute('''
      CREATE TABLE IF NOT EXISTS inventory (
        product_id INTEGER PRIMARY KEY,
        quantity INTEGER NOT NULL DEFAULT 0,

        FOREIGN KEY (product_id)
          REFERENCES products(id)
      );
    ''');

    database.execute('''
      CREATE TABLE IF NOT EXISTS stock_movements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        movement_type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        reference TEXT,
        created_at TEXT NOT NULL,

        FOREIGN KEY (product_id)
          REFERENCES products(id)
      );
    ''');

    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_products_category
      ON products(category_id);
    ''');

    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_stock_movements_product
      ON stock_movements(product_id);
    ''');
  }

  void close() {
    database.close();
  }
}