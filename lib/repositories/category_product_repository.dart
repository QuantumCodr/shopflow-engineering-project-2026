/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Category Product Repository
Description  : Provides SQLite persistence for the
               category-product relationship.
------------------------------------------------------------
*/

import 'package:sqlite3/sqlite3.dart';

import '../core/errors/shopflow_exception.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../enums/product_unit.dart';

abstract interface class CategoryProductRepository {
  void assignProductToCategory(int categoryId, int productId);

  void removeProductFromCategory(int categoryId, int productId);

  bool exists(int categoryId, int productId);

  List<Product> findProductsByCategory(int categoryId);

  List<Category> findCategoriesByProduct(int productId);
}

class SqliteCategoryProductRepository
    implements CategoryProductRepository {
  final Database database;

  SqliteCategoryProductRepository(this.database);

  @override
  void assignProductToCategory(
    int categoryId,
    int productId,
  ) {
    try {
      database.execute(
        '''
        INSERT INTO category_products (
          category_id,
          product_id,
          created_at
        )
        VALUES (?, ?, ?)
        ''',
        [
          categoryId,
          productId,
          DateTime.now().toUtc().toIso8601String(),
        ],
      );
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to assign product to category.',
        cause: error,
      );
    }
  }

  @override
  void removeProductFromCategory(
    int categoryId,
    int productId,
  ) {
    try {
      database.execute(
        '''
        DELETE FROM category_products
        WHERE category_id = ?
          AND product_id = ?
        ''',
        [categoryId, productId],
      );
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to remove product from category.',
        cause: error,
      );
    }
  }

  @override
  bool exists(int categoryId, int productId) {
    try {
      final rows = database.select(
        '''
        SELECT 1
        FROM category_products
        WHERE category_id = ?
          AND product_id = ?
        LIMIT 1
        ''',
        [categoryId, productId],
      );

      return rows.isNotEmpty;
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to check category-product relationship.',
        cause: error,
      );
    }
  }

  @override
  List<Product> findProductsByCategory(int categoryId) {
    try {
      final rows = database.select(
        '''
        SELECT p.*
        FROM products p
        INNER JOIN category_products cp
          ON cp.product_id = p.id
        WHERE cp.category_id = ?
        ORDER BY p.name
        ''',
        [categoryId],
      );

      return rows.map(_productFromRow).toList();
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to retrieve category products.',
        cause: error,
      );
    }
  }

  @override
  List<Category> findCategoriesByProduct(int productId) {
    try {
      final rows = database.select(
        '''
        SELECT c.*
        FROM categories c
        INNER JOIN category_products cp
          ON cp.category_id = c.id
        WHERE cp.product_id = ?
        ORDER BY c.name
        ''',
        [productId],
      );

      return rows.map(_categoryFromRow).toList();
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to retrieve product categories.',
        cause: error,
      );
    }
  }

  Product _productFromRow(Row row) {
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

  Category _categoryFromRow(Row row) {
    return Category(
      id: row['id'] as int,
      name: row['name'] as String,
      description: row['description'] as String?,
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