/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Category Repository
Description  : Provides SQLite persistence for categories.
------------------------------------------------------------
*/

import 'package:sqlite3/sqlite3.dart';

import '../core/errors/shopflow_exception.dart';
import '../models/category.dart';

abstract interface class CategoryRepository {
  Category create(Category category);

  Category? findById(int id);

  Category? findByName(String name);

  List<Category> search(String query);

  List<Category> findAll();

  Category update(Category category);

  void setActive(int id, bool active);
}

class SqliteCategoryRepository implements CategoryRepository {
  final Database database;

  SqliteCategoryRepository(this.database);

  @override
  Category create(Category category) {
    try {
      final statement = database.prepare('''
        INSERT INTO categories (
          name,
          description,
          active,
          created_at,
          updated_at
        )
        VALUES (?, ?, ?, ?, ?)
      ''');

      try {
        statement.execute([
          category.name,
          category.description,
          category.active ? 1 : 0,
          category.createdAt.toUtc().toIso8601String(),
          category.updatedAt.toUtc().toIso8601String(),
        ]);

        final id = database.lastInsertRowId;

        return Category(
          id: id,
          name: category.name,
          description: category.description,
          active: category.active,
          createdAt: category.createdAt,
          updatedAt: category.updatedAt,
        );
      } finally {
        statement.close();
      }
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to create category.',
        cause: error,
      );
    }
  }

  @override
  Category? findById(int id) {
    try {
      final rows = database.select(
        '''
        SELECT *
        FROM categories
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
        message: 'Failed to find category.',
        cause: error,
      );
    }
  }

  @override
  Category? findByName(String name) {
    try {
      final rows = database.select(
        '''
        SELECT *
        FROM categories
        WHERE name = ? COLLATE NOCASE
        ''',
        [name],
      );

      if (rows.isEmpty) {
        return null;
      }

      return _fromRow(rows.first);
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to find category by name.',
        cause: error,
      );
    }
  }

  @override
  List<Category> search(String query) {
    try {
      final searchTerm = '%${query.trim()}%';

      final rows = database.select(
        '''
        SELECT *
        FROM categories
        WHERE name LIKE ? COLLATE NOCASE
           OR description LIKE ? COLLATE NOCASE
        ORDER BY name
        ''',
        [searchTerm, searchTerm],
      );

      return rows.map(_fromRow).toList();
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to search categories.',
        cause: error,
      );
    }
  }

  @override
  List<Category> findAll() {
    try {
      final rows = database.select('''
        SELECT *
        FROM categories
        ORDER BY name
      ''');

      return rows.map(_fromRow).toList();
    } catch (error) {
      throw PersistenceException(
        message: 'Failed to retrieve categories.',
        cause: error,
      );
    }
  }

  @override
  Category update(Category category) {
    if (category.id == null) {
      throw const ValidationException(
        message: 'Category ID is required for an update.',
      );
    }

    try {
      final statement = database.prepare('''
        UPDATE categories
        SET
          name = ?,
          description = ?,
          updated_at = ?
        WHERE id = ?
      ''');

      try {
        statement.execute([
          category.name,
          category.description,
          category.updatedAt.toUtc().toIso8601String(),
          category.id,
        ]);
      } finally {
        statement.close();
      }

      final updated = findById(category.id!);

      if (updated == null) {
        throw const NotFoundException(
          message: 'Category not found.',
        );
      }

      return updated;
    } catch (error) {
      if (error is ShopFlowException) {
        rethrow;
      }

      throw PersistenceException(
        message: 'Failed to update category.',
        cause: error,
      );
    }
  }

  @override
  void setActive(int id, bool active) {
    try {
      final statement = database.prepare('''
        UPDATE categories
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
        message: 'Failed to update category status.',
        cause: error,
      );
    }
  }

  Category _fromRow(Row row) {
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