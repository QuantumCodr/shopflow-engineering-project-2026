/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Database Foundation
Description  : SQLite database configuration and schema.
------------------------------------------------------------
*/

import 'package:sqlite3/sqlite3.dart';

import '../core/errors/shopflow_exception.dart';

class ShopFlowDatabase {
  final Database database;

  ShopFlowDatabase({
    String path = 'data/shopflow.db',
  }) : database = _openDatabase(path) {
    try {
      _configure();
      _createSchema();
    } catch (error) {
      database.close();

      if (error is ShopFlowException) {
        rethrow;
      }

      throw PersistenceException(
        message: 'Failed to initialize the ShopFlow database.',
        cause: error,
      );
    }
  }

  static Database _openDatabase(String path) {
    try {
      return sqlite3.open(path);
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to open the ShopFlow database.',
        cause: error,
      );
    }
  }

  void _configure() {
    database.execute('PRAGMA foreign_keys = ON;');
  }

  void _createSchema() {
    _createCategoriesTable();
    _createProductsTable();
    _createCategoryProductsTable();
    _createInventoryTable();
    _createStockMovementsTable();
    _createSalesTable();
    _createSaleItemsTable();
    _createIndexes();
  }

  void _createCategoriesTable() {
    database.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL COLLATE NOCASE UNIQUE,
        description TEXT,
        active INTEGER NOT NULL DEFAULT 1
          CHECK (active IN (0, 1)),
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      );
    ''');
  }

  void _createProductsTable() {
    database.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        sku TEXT COLLATE NOCASE UNIQUE,
        unit TEXT NOT NULL
          CHECK (
            unit IN (
              'UNKNOWN',
              'PIECE',
              'PACK',
              'BOX',
              'BAG',
              'BOTTLE',
              'CARTON',
              'DOZEN',
              'GRAM',
              'KILOGRAM',
              'MILLILITER',
              'LITER',
              'GALLON',
              'ONE_GALLON'
            )
          ),
        cost_price INTEGER NOT NULL
          CHECK (cost_price >= 0),
        selling_price INTEGER NOT NULL
          CHECK (selling_price >= 0),
        reorder_level INTEGER NOT NULL DEFAULT 0
          CHECK (reorder_level >= 0),
        active INTEGER NOT NULL DEFAULT 1
          CHECK (active IN (0, 1)),
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      );
    ''');
  }

  void _createCategoryProductsTable() {
    database.execute('''
      CREATE TABLE IF NOT EXISTS category_products (
        category_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,

        PRIMARY KEY (category_id, product_id),

        FOREIGN KEY (category_id)
          REFERENCES categories(id)
          ON DELETE CASCADE,

        FOREIGN KEY (product_id)
          REFERENCES products(id)
          ON DELETE CASCADE
      );
    ''');
  }

  void _createInventoryTable() {
    database.execute('''
      CREATE TABLE IF NOT EXISTS inventory (
        product_id INTEGER PRIMARY KEY,
        quantity INTEGER NOT NULL DEFAULT 0
          CHECK (quantity >= 0),

        FOREIGN KEY (product_id)
          REFERENCES products(id)
          ON DELETE CASCADE
      );
    ''');
  }

  void _createStockMovementsTable() {
    database.execute('''
      CREATE TABLE IF NOT EXISTS stock_movements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,

        movement_type TEXT NOT NULL
          CHECK (
            movement_type IN (
              'RECEIPT',
              'SALE',
              'ADJUSTMENT',
              'RETURN'
            )
          ),

        quantity INTEGER NOT NULL
          CHECK (quantity != 0),

        reference TEXT,
        created_at TEXT NOT NULL,

        FOREIGN KEY (product_id)
          REFERENCES products(id)
          ON DELETE CASCADE
      );
    ''');
  }

  void _createSalesTable() {
    database.execute('''
      CREATE TABLE IF NOT EXISTS sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_number TEXT NOT NULL COLLATE NOCASE UNIQUE,
        sale_date TEXT NOT NULL,

        subtotal INTEGER NOT NULL
          CHECK (subtotal >= 0),

        tax_amount INTEGER NOT NULL
          CHECK (tax_amount >= 0),

        total_amount INTEGER NOT NULL
          CHECK (total_amount >= 0),

        payment_amount INTEGER NOT NULL
          CHECK (payment_amount >= 0),

        change_amount INTEGER NOT NULL
          CHECK (change_amount >= 0)
      );
    ''');
  }

  void _createSaleItemsTable() {
    database.execute('''
      CREATE TABLE IF NOT EXISTS sale_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,

        quantity INTEGER NOT NULL
          CHECK (quantity > 0),

        unit_price INTEGER NOT NULL
          CHECK (unit_price >= 0),

        cost_price INTEGER NOT NULL
          CHECK (cost_price >= 0),

        subtotal INTEGER NOT NULL
          CHECK (subtotal >= 0),

        FOREIGN KEY (sale_id)
          REFERENCES sales(id)
          ON DELETE CASCADE,

        FOREIGN KEY (product_id)
          REFERENCES products(id)
      );
    ''');
  }

  void _createIndexes() {
    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_products_name
      ON products(name COLLATE NOCASE);
    ''');

    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_category_products_product
      ON category_products(product_id);
    ''');

    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_category_products_category
      ON category_products(category_id);
    ''');

    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_stock_movements_product
      ON stock_movements(product_id);
    ''');

    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_stock_movements_created_at
      ON stock_movements(created_at);
    ''');

    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_sales_sale_date
      ON sales(sale_date);
    ''');

    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_sale_items_sale
      ON sale_items(sale_id);
    ''');

    database.execute('''
      CREATE INDEX IF NOT EXISTS idx_sale_items_product
      ON sale_items(product_id);
    ''');
  }

  void close() {
    database.close();
  }
}