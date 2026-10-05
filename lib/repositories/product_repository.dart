/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Product Repository
Description  : Provides SQLite persistence for products.
------------------------------------------------------------
*/

import 'package:sqlite3/sqlite3.dart';

import '../core/errors/shopflow_exception.dart';
import '../enums/product_unit.dart';
import '../models/product.dart';

abstract interface class ProductRepository {
  Product create(Product product);

  Product? findById(int id);

  Product? findBySku(String sku);

  List<Product> search(String query);

  List<Product> findAll();

  Product update(Product product);

  void setActive(int id, bool active);
}

class SqliteProductRepository implements ProductRepository {
  final Database database;

  SqliteProductRepository(this.database);

  @override
  Product create(Product product) {
    try {
      final statement = database.prepare('''
        INSERT INTO products (
          name,
          sku,
          unit,
          cost_price,
          selling_price,
          reorder_level,
          active,
          created_at,
          updated_at
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''');

      try {
        statement.execute([
          product.name,
          product.sku,
          product.unit.value,
          product.costPrice,
          product.sellingPrice,
          product.reorderLevel,
          product.active ? 1 : 0,
          product.createdAt.toUtc().toIso8601String(),
          product.updatedAt.toUtc().toIso8601String(),
        ]);

        final id = database.lastInsertRowId;

        return Product(
          id: id,
          name: product.name,
          sku: product.sku,
          unit: product.unit,
          costPrice: product.costPrice,
          sellingPrice: product.sellingPrice,
          reorderLevel: product.reorderLevel,
          active: product.active,
          createdAt: product.createdAt,
          updatedAt: product.updatedAt,
        );
      } finally {
        statement.close();
      }
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to create product.',
        cause: error,
      );
    }
  }

  @override
  Product? findById(int id) {
    try {
      final rows = database.select(
        '''
        SELECT *
        FROM products
        WHERE id = ?
        ''',
        [id],
      );

      if (rows.isEmpty) {
        return null;
      }

      return _fromRow(rows.first);
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to find product.',
        cause: error,
      );
    }
  }

  @override
  Product? findBySku(String sku) {
    try {
      final rows = database.select(
        '''
        SELECT *
        FROM products
        WHERE sku = ? COLLATE NOCASE
        ''',
        [sku],
      );

      if (rows.isEmpty) {
        return null;
      }

      return _fromRow(rows.first);
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to find product by SKU.',
        cause: error,
      );
    }
  }

  @override
  List<Product> search(String query) {
    try {
      final searchTerm = '%${query.trim()}%';

      final rows = database.select(
        '''
        SELECT *
        FROM products
        WHERE name LIKE ? COLLATE NOCASE
           OR sku LIKE ? COLLATE NOCASE
        ORDER BY name
        ''',
        [searchTerm, searchTerm],
      );

      return rows.map(_fromRow).toList();
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to search products.',
        cause: error,
      );
    }
  }

  @override
  List<Product> findAll() {
    try {
      final rows = database.select('''
        SELECT *
        FROM products
        ORDER BY name
      ''');

      return rows.map(_fromRow).toList();
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to retrieve products.',
        cause: error,
      );
    }
  }

  @override
  Product update(Product product) {
    if (product.id == null) {
      throw const ValidationException(
        message: 'Product ID is required for an update.',
      );
    }

    try {
      final statement = database.prepare('''
        UPDATE products
        SET
          name = ?,
          sku = ?,
          unit = ?,
          cost_price = ?,
          selling_price = ?,
          reorder_level = ?,
          updated_at = ?
        WHERE id = ?
      ''');

      try {
        statement.execute([
          product.name,
          product.sku,
          product.unit.value,
          product.costPrice,
          product.sellingPrice,
          product.reorderLevel,
          product.updatedAt.toUtc().toIso8601String(),
          product.id,
        ]);
      } finally {
        statement.close();
      }

      final updated = findById(product.id!);

      if (updated == null) {
        throw const NotFoundException(
          message: 'Product not found.',
        );
      }

      return updated;
    } catch (error) {
      if (error is ShopFlowException) {
        rethrow;
      }

      throw PersistenceException(
        message: 'Failed to update product.',
        cause: error,
      );
    }
  }

  @override
  void setActive(int id, bool active) {
    try {
      final statement = database.prepare('''
        UPDATE products
        SET
          active = ?,
          updated_at = ?
        WHERE id = ?
      ''');

      try {
        statement.execute([
          active ? 1 : 0,
          DateTime.now().toUtc().toIso8601String(),
          id,
        ]);
      } finally {
        statement.close();
      }
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to update product status.',
        cause: error,
      );
    }
  }

  Product _fromRow(Row row) {
    return Product(
      id: row['id'] as int,
      name: row['name'] as String,
      sku: row['sku'] as String?,
      unit: ProductUnit.fromValue(
        row['unit'] as String,
      ),
      costPrice: row['cost_price'] as int,
      sellingPrice: row['selling_price'] as int,
      reorderLevel: row['reorder_level'] as int,
      active: (row['active'] as int) == 1,
      createdAt: DateTime.parse(
        row['created_at'] as String,
      ),
      updatedAt: DateTime.parse(
        row['updated_at'] as String,
      ),
    );
  }
}