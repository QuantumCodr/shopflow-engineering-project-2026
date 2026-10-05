/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Category Product Service
Description  : Manages category-product business rules.
------------------------------------------------------------
*/

import '../core/errors/shopflow_exception.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../repositories/category_product_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/product_repository.dart';

class CategoryProductService {
  final CategoryProductRepository relationshipRepository;
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;

  CategoryProductService(
    this.relationshipRepository,
    this.categoryRepository,
    this.productRepository,
  );

  void assignProductToCategory(
    int categoryId,
    int productId,
  ) {
    _requireCategory(categoryId);
    _requireProduct(productId);

    if (relationshipRepository.exists(
      categoryId,
      productId,
    )) {
      throw const ConflictException(
        message: 'Product is already assigned to this category.',
      );
    }

    relationshipRepository.assignProductToCategory(
      categoryId,
      productId,
    );
  }

  void removeProductFromCategory(
    int categoryId,
    int productId,
  ) {
    _requireCategory(categoryId);
    _requireProduct(productId);

    if (!relationshipRepository.exists(
      categoryId,
      productId,
    )) {
      throw const NotFoundException(
        message: 'Product is not assigned to this category.',
      );
    }

    relationshipRepository.removeProductFromCategory(
      categoryId,
      productId,
    );
  }

  List<Product> findProductsByCategory(int categoryId) {
    _requireCategory(categoryId);

    return relationshipRepository.findProductsByCategory(
      categoryId,
    );
  }

  List<Category> findCategoriesByProduct(int productId) {
    _requireProduct(productId);

    return relationshipRepository.findCategoriesByProduct(
      productId,
    );
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