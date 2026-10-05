/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Category Service
Description  : Contains category business rules and
               validation.
------------------------------------------------------------
*/

import '../core/errors/shopflow_exception.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository categoryRepository;

  CategoryService(this.categoryRepository);

  Category create({
    required String name,
    String? description,
  }) {
    final cleanName = name.trim();
    final cleanDescription = description?.trim();

    if (cleanName.isEmpty) {
      throw const ValidationException(
        message: 'Category name cannot be empty.',
      );
    }

    if (categoryRepository.findByName(cleanName) != null) {
      throw const ConflictException(
        message: 'Category name already exists.',
      );
    }

    final now = DateTime.now();

    return categoryRepository.create(
      Category(
        name: cleanName,
        description: cleanDescription == null ||
                cleanDescription.isEmpty
            ? null
            : cleanDescription,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Category? findById(int id) {
    return categoryRepository.findById(id);
  }

  Category? findByName(String name) {
    final cleanName = name.trim();

    if (cleanName.isEmpty) {
      throw const ValidationException(
        message: 'Category name cannot be empty.',
      );
    }

    return categoryRepository.findByName(cleanName);
  }

  List<Category> search(String query) {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      throw const ValidationException(
        message: 'Search query cannot be empty.',
      );
    }

    return categoryRepository.search(cleanQuery);
  }

  List<Category> findAll() {
    return categoryRepository.findAll();
  }

  Category update({
    required int id,
    required String name,
    String? description,
  }) {
    final existing = categoryRepository.findById(id);

    if (existing == null) {
      throw const NotFoundException(
        message: 'Category not found.',
      );
    }

    final cleanName = name.trim();
    final cleanDescription = description?.trim();

    if (cleanName.isEmpty) {
      throw const ValidationException(
        message: 'Category name cannot be empty.',
      );
    }

    final categoryWithName =
        categoryRepository.findByName(cleanName);

    if (categoryWithName != null &&
        categoryWithName.id != id) {
      throw const ConflictException(
        message: 'Category name already exists.',
      );
    }

    return categoryRepository.update(
      Category(
        id: existing.id,
        name: cleanName,
        description: cleanDescription == null ||
                cleanDescription.isEmpty
            ? null
            : cleanDescription,
        active: existing.active,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void activate(int id) {
    _requireCategory(id);

    categoryRepository.setActive(id, true);
  }

  void deactivate(int id) {
    _requireCategory(id);

    categoryRepository.setActive(id, false);
  }

  Category _requireCategory(int id) {
    final category = categoryRepository.findById(id);

    if (category == null) {
      throw const NotFoundException(
        message: 'Category not found.',
      );
    }

    return category;
  }
}