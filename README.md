# ShopFlow

**Small Business Management System**

> A simple management system that helps small retail shops manage their products, inventory, purchases, sales, customers, suppliers, employees, and basic business reports in one place.

---

## 1. Project Overview

ShopFlow is a small business management system designed for small retail shops.

Many small retail businesses rely on notebooks, receipts, calculators, memory, spreadsheets, or separate records to manage their daily operations. This can make it difficult to maintain accurate records of products, inventory, purchases, sales, customers, suppliers, and business performance.

ShopFlow aims to provide a simple and centralized system for managing these activities.

The first version of ShopFlow is being developed as a Dart console application with SQLite persistence. The project is intentionally being developed in stages so that the initial system can evolve into a larger application without requiring the core business logic to be rewritten.

---

## 2. Problem Statement

Small retail businesses often lack a simple, centralized system for managing their day-to-day product, inventory, purchasing, and sales operations.

This can result in:

- inefficient record keeping;
- difficulty tracking available stock;
- inaccurate or incomplete sales records;
- limited visibility into business performance;
- difficulty identifying low-stock products;
- difficulty determining which products sell well; and
- difficulty making informed business decisions.

ShopFlow is intended to address these problems through a centralized business management system.

---

## 3. Project Objectives

The main objectives of ShopFlow are to:

1. Manage product categories.
2. Manage products and their pricing information.
3. Track inventory levels.
4. Record stock movements.
5. Process sales through a point-of-sale workflow.
6. Maintain sales records.
7. Provide basic business reports.
8. Reduce dependence on manual record keeping.
9. Demonstrate sound software engineering principles.
10. Establish a foundation that can be extended into a larger application.

---

## 4. Assignment 1 Scope

Assignment 1 focuses on the core operational workflow of a small retail shop.

### Included

- Categories
- Products
- Inventory
- Stock movements
- Point of Sale
- Sales
- Basic reports
- SQLite data persistence
- Dart console interface
- Automated tests

### Not Included in Version 0.1

The following features are intentionally deferred:

- Flutter mobile application
- Online ordering
- Delivery management
- GPS/location services
- Marketplace functionality
- Supplier management
- Purchase management
- Customer management
- Employee management
- Authentication
- Advanced authorization
- Cloud database
- Supabase integration
- API/backend communication
- Multi-branch management
- Payroll
- Accounting
- Advanced analytics
- Artificial intelligence

These features may be considered in later versions where they are justified by project requirements.

---

## 5. Core Business Workflow

The core workflow of Version 0.1 is:

```text
Category
   ↓
Product
   ↓
Inventory
   ↓
Point of Sale
   ↓
Sale
   ↓
Inventory Update
   ↓
Stock Movement
   ↓
Business Reports

A completed sale should result in:

Validation of the selected products.
Validation of requested quantities.
Verification of available stock.
Calculation of the sale subtotal.
Calculation of applicable tax.
Calculation of the final total.
Validation of the customer's payment.
Creation of the sale record.
Creation of sale-item records.
Reduction of inventory.
Recording of the corresponding stock movements.
Availability of updated information for reporting.
6. Architecture

ShopFlow is being developed using a layered architecture.

Initial Architecture
┌─────────────────────────────┐
│            CLI              │
│      User Interaction       │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│          SERVICES           │
│       Business Logic        │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│        REPOSITORIES         │
│       Data Access           │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│           SQLite            │
│       Data Persistence      │
└─────────────────────────────┘
Architectural Responsibilities
CLI

Responsible for:

displaying information;
collecting user input;
presenting results;
handling basic interaction flow.

The CLI should not contain core business rules.

Services

Responsible for:

business rules;
validation;
calculations;
application workflows;
coordinating multiple repositories;
enforcing business constraints.
Repositories

Responsible for:

data access;
persistence;
retrieving records;
storing records;
updating records.

Repositories should not contain application-level business decisions.

Database

Responsible for persistent storage.

SQLite is used for the first version.

7. Domain Models

The initial domain includes:

Category
Product
Sale
SaleItem
StockMovement

The domain will expand as the system evolves.

Potential future entities include:

Supplier
Purchase
PurchaseItem
Customer
Employee
Tax
8. Project Structure

The initial project structure is planned as:

shopflow/
│
├── bin/
│   └── shopflow.dart
│
├── lib/
│   ├── models/
│   │   ├── category.dart
│   │   ├── product.dart
│   │   ├── sale.dart
│   │   ├── sale_item.dart
│   │   └── stock_movement.dart
│   │
│   ├── repositories/
│   │   ├── category_repository.dart
│   │   ├── product_repository.dart
│   │   ├── inventory_repository.dart
│   │   └── sale_repository.dart
│   │
│   ├── services/
│   │   ├── category_service.dart
│   │   ├── product_service.dart
│   │   ├── inventory_service.dart
│   │   ├── pos_service.dart
│   │   └── report_service.dart
│   │
│   └── database/
│       └── database.dart
│
├── test/
│
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
└── CHANGELOG.md

The structure will evolve as new requirements are introduced. New abstractions should only be introduced when they provide a clear architectural benefit.

9. Development Principles

ShopFlow is being developed using the following principles:

Build incrementally

Each feature should be implemented, tested, integrated, and verified before moving to the next major feature.

Separate responsibilities

Each layer should have a clear responsibility.

Keep business logic independent of the interface

Business rules should not depend on the CLI.

This allows future interfaces such as Flutter or an API to reuse the same application logic.

Prefer extension over rewriting

The project should evolve from its existing foundation.

Future functionality should extend existing architecture rather than requiring unnecessary rewrites.

Avoid premature complexity

The project should remain as simple as possible while still being correctly engineered.

Test behavior

Tests should verify meaningful application behavior rather than simply testing implementation details.

10. Development Roadmap
Version 0.1 — Assignment 1
Project Foundation
        ↓
Database Foundation
        ↓
Categories
        ↓
Products
        ↓
Inventory
        ↓
Point of Sale
        ↓
Sales
        ↓
Reports
        ↓
CLI Integration
        ↓
Testing
        ↓
Documentation
Future Development

Potential future evolution:

ShopFlow CLI
     ↓
Expanded Business Features
     ↓
Dart Backend/API
     ↓
Flutter Application
     ↓
Supabase PostgreSQL
     ↓
Authentication & Authorization
     ↓
Production-Oriented System
11. Future Backend Direction

The initial version uses SQLite and a console interface.

The long-term architecture is intended to allow the project to evolve toward:

Flutter
   ↓
Dart API / Backend
   ↓
Application Services
   ↓
Repositories
   ↓
Supabase PostgreSQL

The business logic should remain in the application/backend layer rather than being duplicated inside the Flutter interface.

Supabase may later provide infrastructure services such as:

PostgreSQL database hosting;
authentication;
session management;
database security;
cloud infrastructure.

The use of Supabase is intentionally deferred from Assignment 1.

12. Authentication Direction

Authentication is not part of the initial Version 0.1 implementation.

In a future version:

User
  ↓
Supabase Authentication
  ↓
Authenticated Identity
  ↓
Dart Backend
  ↓
Authorization
  ↓
Business Services

Supabase would handle authentication infrastructure, while the ShopFlow application would handle application-level authorization and business rules.

13. Testing Strategy

Testing will focus on system behavior.

Examples include:

creating valid categories;
rejecting invalid categories;
creating valid products;
rejecting invalid product information;
preventing sales of inactive products;
preventing sales exceeding available stock;
calculating correct subtotals;
calculating correct taxes;
calculating correct totals;
validating payment;
updating inventory after a sale;
recording stock movements;
generating correct basic reports.

The goal is to verify that the system behaves correctly from the perspective of the business requirements.

14. Engineering Workflow

Each major feature follows this general workflow:

Requirement
    ↓
Design
    ↓
Model
    ↓
Repository
    ↓
Service
    ↓
Tests
    ↓
CLI Integration
    ↓
Manual Verification
    ↓
Documentation
    ↓
Freeze

A completed feature becomes part of the stable foundation for subsequent features.

15. Current Status

Version: 0.1.0-dev

Current stage:

[✓] Project concept
[✓] Problem definition
[✓] Initial scope
[✓] Initial architecture
[✓] Initial domain design
[ ] Dart project implementation
[ ] Database implementation
[ ] Category module
[ ] Product module
[ ] Inventory module
[ ] POS module
[ ] Sales module
[ ] Reports
[ ] CLI integration
[ ] Automated testing
[ ] Final documentation
16. Project Philosophy

Build a small complete system rather than a large incomplete system.

ShopFlow is intentionally being developed as an evolving software project.

The first version should be small enough to understand, test, and complete, while being structured well enough to support future development.

17. Author

Author: QuantumCodr
Project: ShopFlow
Language: Dart
Initial Version: 0.1.0
Development Approach: Incremental, test-driven, layered architecture