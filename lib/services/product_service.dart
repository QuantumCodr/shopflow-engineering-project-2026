/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Product Service
Description  : Contains product business rules and
               validation.
------------------------------------------------------------
*/

import '../core/errors/shopflow_exception.dart';
import '../enums/product_unit.dart';
import '../models/product.dart';
import '../repositories/category_repository.dart';
import '../repositories/product_repository.dart';

class ProductService {
  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;

  ProductService(
    this.productRepository,
    this.categoryRepository,
  );

  Product create({
    required String name,
    String? sku,
    required ProductUnit unit,
    required int costPrice,
    required int sellingPrice,
    int reorderLevel = 0,
  }) {
    final cleanName = name.trim();
    final cleanSku = sku?.trim();

    if (cleanName.isEmpty) {
      throw const ValidationException(
        message: 'Product name cannot be empty.',
      );
    }

    if (cleanSku != null && cleanSku.isEmpty) {
      throw const ValidationException(
        message: 'SKU cannot be empty when provided.',
      );
    }

    if (costPrice < 0) {
      throw const ValidationException(
        message: 'Cost price cannot be negative.',
      );
    }

    if (sellingPrice < 0) {
      throw const ValidationException(
        message: 'Selling price cannot be negative.',
      );
    }

    if (reorderLevel < 0) {
      throw const ValidationException(
        message: 'Reorder level cannot be negative.',
      );
    }

    if (cleanSku != null &&
        productRepository.findBySku(cleanSku) != null) {
      throw const ConflictException(
        message: 'A product with this SKU already exists.',
      );
    }

    final now = DateTime.now();

    return productRepository.create(
      Product(
        name: cleanName,
        sku: cleanSku,
        unit: unit,
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        reorderLevel: reorderLevel,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Product? findById(int id) {
    return productRepository.findById(id);
  }

  Product? findBySku(String sku) {
    final cleanSku = sku.trim();

    if (cleanSku.isEmpty) {
      throw const ValidationException(
        message: 'SKU cannot be empty.',
      );
    }

    return productRepository.findBySku(cleanSku);
  }

  List<Product> search(String query) {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      throw const ValidationException(
        message: 'Search query cannot be empty.',
      );
    }

    return productRepository.search(cleanQuery);
  }

  List<Product> findAll() {
    return productRepository.findAll();
  }

  Product update({
    required int id,
    required String name,
    String? sku,
    required ProductUnit unit,
    required int costPrice,
    required int sellingPrice,
    required int reorderLevel,
  }) {
    final existing = productRepository.findById(id);

    if (existing == null) {
      throw const NotFoundException(
        message: 'Product not found.',
      );
    }

    final cleanName = name.trim();
    final cleanSku = sku?.trim();

    if (cleanName.isEmpty) {
      throw const ValidationException(
        message: 'Product name cannot be empty.',
      );
    }

    if (cleanSku != null && cleanSku.isEmpty) {
      throw const ValidationException(
        message: 'SKU cannot be empty when provided.',
      );
    }

    if (costPrice < 0) {
      throw const ValidationException(
        message: 'Cost price cannot be negative.',
      );
    }

    if (sellingPrice < 0) {
      throw const ValidationException(
        message: 'Selling price cannot be negative.',
      );
    }

    if (reorderLevel < 0) {
      throw const ValidationException(
        message: 'Reorder level cannot be negative.',
      );
    }

    if (cleanSku != null) {
      final productWithSku = productRepository.findBySku(cleanSku);

      if (productWithSku != null && productWithSku.id != id) {
        throw const ConflictException(
          message: 'A product with this SKU already exists.',
        );
      }
    }

    final updatedProduct = Product(
      id: existing.id,
      name: cleanName,
      sku: cleanSku,
      unit: unit,
      costPrice: costPrice,
      sellingPrice: sellingPrice,
      reorderLevel: reorderLevel,
      active: existing.active,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );

    return productRepository.update(updatedProduct);
  }

  void deactivate(int id) {
    _requireProduct(id);

    productRepository.setActive(id, false);
  }

  void activate(int id) {
    _requireProduct(id);

    productRepository.setActive(id, true);
  }

  Product _requireProduct(int id) {
    final product = productRepository.findById(id);

    if (product == null) {
      throw const NotFoundException(
        message: 'Product not found.',
      );
    }

    return product;
  }
}