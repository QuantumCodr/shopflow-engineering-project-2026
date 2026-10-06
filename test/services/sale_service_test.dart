/*
------------------------------------------------------------
Program Name : ShopFlow
Author       : QuantumCodr
Date         : 2026-10-05
Language     : Dart
Topic        : Sale Service Tests
Description  : Tests sales and POS business rules.
------------------------------------------------------------
*/

import 'package:test/test.dart';

import 'package:shopflow/core/errors/shopflow_exception.dart';
import 'package:shopflow/database/database.dart';
import 'package:shopflow/models/product.dart';
import 'package:shopflow/repositories/inventory_repository.dart';
import 'package:shopflow/repositories/product_repository.dart';
import 'package:shopflow/repositories/sale_item_repository.dart';
import 'package:shopflow/repositories/sale_repository.dart';
import 'package:shopflow/services/sale_service.dart';

void main() {
  late ShopFlowDatabase database;
  late ProductRepository productRepository;
  late InventoryRepository inventoryRepository;
  late SaleRepository saleRepository;
  late SaleItemRepository saleItemRepository;
  late SaleService saleService;

  setUp(() {
    database = ShopFlowDatabase(path: ':memory:');

    productRepository = SqliteProductRepository(
      database.database,
    );

    inventoryRepository = SqliteInventoryRepository(
      database.database,
    );

    saleRepository = SqliteSaleRepository(
      database.database,
    );

    saleItemRepository = SqliteSaleItemRepository(
      database.database,
    );

    saleService = SaleService(
      saleRepository,
      saleItemRepository,
      productRepository,
      inventoryRepository,
      database,
      taxRate: 0.10,
    );
  });

  tearDown(() {
    database.close();
  });

  Product createProduct({
    String name = 'Onga',
    int costPrice = 40,
    int sellingPrice = 70,
    bool active = true,
  }) {
    final now = DateTime.now().toUtc();

    return productRepository.create(
      Product(
        name: name,
        sku: name.toUpperCase(),
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        active: active,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  test('completes a sale successfully', () {
    final product = createProduct();

    inventoryRepository.receiveStock(
      product.id!,
      10,
    );

    final sale = saleService.completeSale(
      saleNumber: 'SALE-001',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 2,
        ),
      ],
      paymentAmount: 200,
    );

    expect(sale.saleNumber, 'SALE-001');
    expect(sale.subtotal, 140);
    expect(sale.taxAmount, 14);
    expect(sale.totalAmount, 154);
    expect(sale.paymentAmount, 200);
    expect(sale.changeAmount, 46);
  });

  test('creates sale items with the correct price and cost snapshot', () {
    final product = createProduct(
      costPrice: 40,
      sellingPrice: 70,
    );

    inventoryRepository.receiveStock(
      product.id!,
      10,
    );

    final sale = saleService.completeSale(
      saleNumber: 'SALE-002',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 2,
        ),
      ],
      paymentAmount: 200,
    );

    final items = saleService.findItems(sale.id!);

    expect(items.length, 1);
    expect(items.first.productId, product.id);
    expect(items.first.quantity, 2);
    expect(items.first.unitPrice, 70);
    expect(items.first.costPrice, 40);
    expect(items.first.subtotal, 140);
  });

  test('reduces inventory after a sale', () {
    final product = createProduct();

    inventoryRepository.receiveStock(
      product.id!,
      10,
    );

    saleService.completeSale(
      saleNumber: 'SALE-003',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 3,
        ),
      ],
      paymentAmount: 300,
    );

    final inventory = inventoryRepository.getByProductId(
      product.id!,
    );

    expect(inventory.quantity, 7);
  });

  test('records a sale stock movement', () {
    final product = createProduct();

    inventoryRepository.receiveStock(
      product.id!,
      10,
    );

    saleService.completeSale(
      saleNumber: 'SALE-004',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 3,
        ),
      ],
      paymentAmount: 300,
    );

    final movements = inventoryRepository.findMovementsByProduct(
      product.id!,
    );

    expect(movements.length, 2);
    expect(movements.first.movementType.value, 'SALE');
    expect(movements.first.quantity, -3);
    expect(movements.first.reference, 'SALE-004');
  });

  test('rejects a sale when stock is insufficient', () {
    final product = createProduct();

    inventoryRepository.receiveStock(
      product.id!,
      2,
    );

    expect(
      () => saleService.completeSale(
        saleNumber: 'SALE-005',
        items: [
          SaleItemRequest(
            productId: product.id!,
            quantity: 3,
          ),
        ],
        paymentAmount: 300,
      ),
      throwsA(isA<BusinessRuleException>()),
    );
  });

  test('rejects an inactive product', () {
    final product = createProduct(
      active: false,
    );

    inventoryRepository.receiveStock(
      product.id!,
      10,
    );

    expect(
      () => saleService.completeSale(
        saleNumber: 'SALE-006',
        items: [
          SaleItemRequest(
            productId: product.id!,
            quantity: 1,
          ),
        ],
        paymentAmount: 100,
      ),
      throwsA(isA<BusinessRuleException>()),
    );
  });

  test('rejects a zero quantity', () {
    final product = createProduct();

    expect(
      () => saleService.completeSale(
        saleNumber: 'SALE-007',
        items: [
          SaleItemRequest(
            productId: product.id!,
            quantity: 0,
          ),
        ],
        paymentAmount: 100,
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('rejects a negative quantity', () {
    final product = createProduct();

    expect(
      () => saleService.completeSale(
        saleNumber: 'SALE-008',
        items: [
          SaleItemRequest(
            productId: product.id!,
            quantity: -1,
          ),
        ],
        paymentAmount: 100,
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('rejects an empty sale', () {
    expect(
      () => saleService.completeSale(
        saleNumber: 'SALE-009',
        items: [],
        paymentAmount: 100,
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('rejects payment below the sale total', () {
    final product = createProduct();

    inventoryRepository.receiveStock(
      product.id!,
      10,
    );

    expect(
      () => saleService.completeSale(
        saleNumber: 'SALE-010',
        items: [
          SaleItemRequest(
            productId: product.id!,
            quantity: 2,
          ),
        ],
        paymentAmount: 100,
      ),
      throwsA(isA<BusinessRuleException>()),
    );
  });

  test('rejects a duplicate sale number', () {
    final product = createProduct();

    inventoryRepository.receiveStock(
      product.id!,
      10,
    );

    saleService.completeSale(
      saleNumber: 'SALE-011',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 1,
        ),
      ],
      paymentAmount: 100,
    );

    expect(
      () => saleService.completeSale(
        saleNumber: 'SALE-011',
        items: [
          SaleItemRequest(
            productId: product.id!,
            quantity: 1,
          ),
        ],
        paymentAmount: 100,
      ),
      throwsA(isA<ConflictException>()),
    );
  });

  test('rolls back the complete sale when a sale operation fails', () {
    final product = createProduct();

    inventoryRepository.receiveStock(
      product.id!,
      1,
    );

    expect(
      () => saleService.completeSale(
        saleNumber: 'SALE-012',
        items: [
          SaleItemRequest(
            productId: product.id!,
            quantity: 2,
          ),
        ],
        paymentAmount: 200,
      ),
      throwsA(isA<BusinessRuleException>()),
    );

    expect(
      saleRepository.findBySaleNumber('SALE-012'),
      isNull,
    );

    expect(
      inventoryRepository.getByProductId(product.id!).quantity,
      1,
    );
  });

  test('finds a sale by sale number', () {
    final product = createProduct();

    inventoryRepository.receiveStock(
      product.id!,
      10,
    );

    saleService.completeSale(
      saleNumber: 'SALE-013',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 1,
        ),
      ],
      paymentAmount: 100,
    );

    final sale = saleService.findBySaleNumber(
      'SALE-013',
    );

    expect(sale, isNotNull);
    expect(sale!.saleNumber, 'SALE-013');
  });

  test('finds all completed sales', () {
    final product = createProduct();

    inventoryRepository.receiveStock(
      product.id!,
      10,
    );

    saleService.completeSale(
      saleNumber: 'SALE-014',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 1,
        ),
      ],
      paymentAmount: 100,
    );

    saleService.completeSale(
      saleNumber: 'SALE-015',
      items: [
        SaleItemRequest(
          productId: product.id!,
          quantity: 1,
        ),
      ],
      paymentAmount: 100,
    );

    final sales = saleService.findAll();

    expect(sales.length, 2);
  });

  test(
    'rejects duplicate cart items when combined quantity exceeds stock',
    () {
      final product = createProduct();

      inventoryRepository.receiveStock(
        product.id!,
        3,
      );

      expect(
        () => saleService.completeSale(
          saleNumber: 'SALE-016',
          items: [
            SaleItemRequest(
              productId: product.id!,
              quantity: 2,
            ),
            SaleItemRequest(
              productId: product.id!,
              quantity: 2,
            ),
          ],
          paymentAmount: 300,
        ),
        throwsA(isA<BusinessRuleException>()),
      );

      expect(
        saleRepository.findBySaleNumber('SALE-016'),
        isNull,
      );

      expect(
        inventoryRepository.getByProductId(product.id!).quantity,
        3,
      );
    },
  );
}