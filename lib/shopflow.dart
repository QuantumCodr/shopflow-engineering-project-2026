/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-04
Language     : Dart
Topic        : Library Exports
Description  : Exposes the main ShopFlow application
               components through a single package entry point.
------------------------------------------------------------
*/

export 'core/errors/shopflow_exception.dart';

export 'database/database.dart';

export 'enums/product_unit.dart';
export 'enums/stock_movement_type.dart';

export 'models/category.dart';
export 'models/product.dart';
export 'models/inventory.dart';

export 'repositories/category_repository.dart';
export 'repositories/product_repository.dart';
export 'repositories/inventory_repository.dart';

export 'services/category_service.dart';
export 'services/product_service.dart';
export 'services/inventory_service.dart';

export 'repositories/category_product_repository.dart';
export 'services/category_product_service.dart';