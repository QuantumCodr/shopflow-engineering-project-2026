# ShopFlow

### Small Business Management System

ShopFlow is a Dart-based business management prototype designed to help small retail shops manage product categories, products, inventory, stock movements, sales, and basic business reports through a console interface.

The project demonstrates how software engineering principles can be applied to a practical retail management problem through a layered architecture, structured data persistence, business-rule validation, and automated testing.

**Project:** ShopFlow — Small Business Management System
**Language:** Dart
**Database:** SQLite
**Interface:** Command-line interface (CLI)
**Version:** 0.1.0
**Repository:** https://github.com/QuantumCodr/shopflow-engineering-project-2026

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Problem Statement](#2-problem-statement)
3. [Project Objectives](#3-project-objectives)
4. [Current Features](#4-current-features)
5. [Project Scope](#5-project-scope)
6. [Technology Stack](#6-technology-stack)
7. [System Requirements](#7-system-requirements)
8. [Getting Started](#8-getting-started)
9. [Running the Application](#9-running-the-application)
10. [Running the Tests](#10-running-the-tests)
11. [System Architecture](#11-system-architecture)
12. [Core Business Workflow](#12-core-business-workflow)
13. [Data and Persistence](#13-data-and-persistence)
14. [Project Structure](#14-project-structure)
15. [Testing Strategy](#15-testing-strategy)
16. [Database Safety](#16-database-safety)
17. [Current Limitations](#17-current-limitations)
18. [Future Development](#18-future-development)
19. [Contributing](#19-contributing)
20. [License](#20-license)

---

## 1. Project Overview

Small retail businesses need reliable ways to manage their products, monitor stock, record sales, and understand their business performance.

When these activities are handled through separate notebooks, receipts, calculators, spreadsheets, or memory, maintaining accurate and consistent records can become difficult.

ShopFlow is a software prototype intended to address these challenges by bringing selected retail operations into one system.

The initial version uses Dart for application logic and SQLite for local data persistence. Its console interface allows a user to interact with the system without requiring a web application, mobile application, or cloud service.

The project is being developed incrementally. The current version focuses on essential retail operations while establishing a foundation for future development.

## 2. Problem Statement

Small retail businesses may experience difficulties maintaining accurate product, inventory, and sales records when their operations depend on manual or disconnected record-keeping methods.

Potential consequences include:

* Inefficient record keeping.
* Difficulty determining available stock.
* Incomplete or inaccurate sales records.
* Difficulty identifying products that need restocking.
* Limited visibility into sales performance.
* Difficulty determining the profitability of recorded sales.
* Delayed or poorly informed business decisions.

ShopFlow proposes a centralized software solution for selected retail management activities.

The project represents a software-engineering prototype. Claims about the practices of a particular retail business should be supported by actual observations or interviews rather than assumed.

## 3. Project Objectives

The objectives of ShopFlow are to:

1. Manage product categories.
2. Manage products and their pricing information.
3. Track inventory quantities.
4. Record stock movements.
5. Process sales through a point-of-sale workflow.
6. Maintain sales and sale-item records.
7. Generate basic business reports.
8. Reduce dependence on disconnected record-keeping methods.
9. Demonstrate separation of responsibilities in application architecture.
10. Apply validation, persistence, and automated testing.
11. Establish a foundation for future system development.

## 4. Current Features

The initial version focuses on the following functionality.

### 4.1 Category Management

Supports the management of product categories used to organize retail products.

### 4.2 Product Management

Manages product information, including applicable identification, unit, pricing, reorder-level, and active-status fields.

### 4.3 Inventory Tracking

Maintains inventory information for products and supports stock-related operations.

### 4.4 Stock Movements

Records inventory movements associated with supported operations, helping maintain a record of stock changes.

### 4.5 Point of Sale

Provides a sales workflow that validates selected products and quantities, checks stock availability, calculates the sale amount, and validates payment.

### 4.6 Sales Records

Stores sales and their associated sale items so that completed transactions can be retrieved and reviewed.

### 4.7 Business Reports

Provides basic reports covering areas such as:

* Sales summaries.
* Product sales.
* Inventory levels.
* Low-stock products.

### 4.8 SQLite Persistence

Uses SQLite to persist application data locally.

### 4.9 Automated Tests

Includes automated tests for application behavior.

The implemented behavior should be verified against the current source code and test suite before this README is used as evidence for a specific feature.

## 5. Project Scope

### Included in Version 0.1

The current project scope includes:

* Product categories.
* Products.
* Inventory.
* Stock movements.
* Point of Sale.
* Sales records.
* Basic reports.
* SQLite persistence.
* Dart console interface.
* Automated tests.

### Outside the Current Scope

The following features are not part of the initial version:

* Flutter mobile application.
* Online ordering.
* Delivery management.
* GPS and location services.
* Marketplace functionality.
* Supplier management.
* Purchase management.
* Customer management.
* Employee management.
* Authentication and advanced authorization.
* Cloud database integration.
* Supabase integration.
* API or backend services.
* Multi-branch management.
* Payroll.
* Full accounting.
* Advanced analytics.
* Artificial intelligence.

These features may be considered in future versions if justified by the project's requirements.

## 6. Technology Stack

| Technology | Purpose                               |
| ---------- | ------------------------------------- |
| Dart       | Application programming language      |
| SQLite     | Local relational data persistence     |
| `sqlite3`  | SQLite database access                |
| `path`     | File-path utilities                   |
| `test`     | Automated testing                     |
| `lints`    | Dart code analysis rules              |
| Git        | Version control                       |
| GitHub     | Source-code hosting and collaboration |

Dependency versions and SDK requirements are defined in `pubspec.yaml`.

## 7. System Requirements

To obtain and run the project, you need:

* Git installed on your computer.
* A Dart SDK compatible with the SDK constraint in `pubspec.yaml`.
* A terminal or command-line environment.
* Sufficient permissions to read and write the project directory and its database files.

Visual Studio Code or another code editor is recommended for inspecting and modifying the source code, but a graphical editor is not required to execute the console application.

Verify the installations:

```bash
git --version
dart --version
```

The current `pubspec.yaml` specifies the Dart SDK constraint `^3.13.4`. Use a compatible SDK.

## 8. Getting Started

### Step 1: Clone the Repository

Open a terminal and run:

```bash
git clone https://github.com/QuantumCodr/shopflow-engineering-project-2026.git
```

Enter the project directory:

```bash
cd shopflow-engineering-project-2026
```

### Step 2: Inspect the Project

Confirm that you are in the repository root, where `pubspec.yaml` is located.

You can inspect the directory contents with:

**Windows PowerShell**

```powershell
Get-ChildItem
```

**macOS/Linux**

```bash
ls
```

### Step 3: Install Dependencies

Run:

```bash
dart pub get
```

This resolves and downloads the dependencies declared in `pubspec.yaml`.

If dependency resolution fails, check the installed Dart version and compare it with the project's SDK constraint.

### Step 4: Open the Project in an Editor

If Visual Studio Code is installed and its `code` command is available, run:

```bash
code .
```

Otherwise, open the repository folder using your editor's graphical interface.

## 9. Running the Application

From the repository root, execute:

```bash
dart run bin/shopflow.dart
```

The application should display its console interface and allow the user to interact with the available operations.

Follow the instructions shown by the application.

ShopFlow is a console application. It does not require a browser, Flutter runtime, or hosted backend for its current local workflow.

### Updating an Existing Clone

If you already cloned the repository and want to obtain the latest committed changes, run:

```bash
git switch main
git pull origin main
dart pub get
```

If you have local changes, inspect and preserve them before switching branches or pulling updates.

### Troubleshooting

**The `dart` command is not recognized.**

Install a compatible Dart SDK and ensure its `bin` directory is available through your system's `PATH`. Open a new terminal after changing environment variables.

**Dependency resolution fails.**

Check the Dart SDK version and the constraints declared in `pubspec.yaml`. Review the error message before changing dependency versions.

**The application cannot access its database.**

Check the database path, file permissions, and any error messages produced by the application. Back up existing data before attempting repairs.

**The application does not start.**

Confirm that you are in the repository root, that dependencies have been resolved, and that `bin/shopflow.dart` exists.

Do not delete or recreate the database as a general troubleshooting step.

## 10. Running the Tests

ShopFlow uses the Dart test package.

Run the complete automated test suite from the repository root:

```bash
dart test
```

Run static analysis:

```bash
dart analyze
```

The analyzer checks the Dart code for issues identified by the project's analysis rules.

Both commands should be executed before submitting the project or proposing changes.

Previously recorded verification results were:

* Static analysis: no issues found.
* Automated tests: 28 tests passed.

These results describe the previously verified state. Run the commands again to confirm the current repository state before relying on them in an academic submission.

## 11. System Architecture

ShopFlow follows a layered architecture designed to separate user interaction, business logic, data access, and persistence.

```text
+----------------------------------+
|               CLI                |
|         User Interaction         |
+----------------------------------+
                 |
                 v
+----------------------------------+
|             Services             |
| Validation and Business Logic    |
+----------------------------------+
                 |
                 v
+----------------------------------+
|            Repositories          |
|             Data Access          |
+----------------------------------+
                 |
                 v
+----------------------------------+
|              SQLite              |
|          Data Persistence        |
+----------------------------------+
```

### 11.1 Command-Line Interface

The CLI is responsible for:

* Displaying menus and information.
* Collecting user input.
* Calling application services.
* Presenting operation results.
* Managing the interaction flow.

The CLI should not become the primary location for business rules.

### 11.2 Services

Services implement application workflows and business rules.

Their responsibilities include:

* Input and business-rule validation.
* Calculations.
* Stock and sales workflow coordination.
* Coordination between repositories.
* Enforcement of relevant business constraints.

### 11.3 Repositories

Repositories are responsible for data access and persistence operations.

Their responsibilities include:

* Retrieving records.
* Storing records.
* Updating records.
* Executing database queries through the data-access layer.

Application-level business decisions should remain in the service layer.

### 11.4 Database Layer

SQLite provides local persistence for supported application data.

Database initialization, transaction handling, and database-specific operations belong in the appropriate database or data-access components.

### Architectural Benefit

Separating these responsibilities helps make the application easier to understand, test, maintain, and extend.

It also creates a foundation for future interfaces that could reuse the business logic rather than duplicating it in the user interface.

## 12. Core Business Workflow

The main business workflow connects product information, inventory, sales, and reporting.

```text
Category Management
        |
        v
Product Management
        |
        v
Inventory Tracking
        |
        v
Point of Sale
        |
        v
Sale and Sale Items
        |
        v
Inventory Update
        |
        v
Stock Movement Records
        |
        v
Business Reports
```

### Sale Processing

A completed sale should follow the applicable validation and transaction rules:

1. Validate the sale information.
2. Confirm that the sale contains valid items.
3. Validate product availability and active status.
4. Validate requested quantities.
5. Check that sufficient stock is available.
6. Calculate the subtotal.
7. Calculate the applicable configured tax.
8. Calculate the final total.
9. Validate the customer's payment.
10. Record the sale and sale items.
11. Reduce the relevant inventory quantities.
12. Record the corresponding stock movements.
13. Make the updated information available to reports.

The exact behavior should be verified against the implemented service logic and tests.

### Transaction Integrity

Where the sale workflow uses a database transaction, related changes should succeed or fail together. This helps prevent a sale from being recorded without its corresponding inventory updates.

## 13. Data and Persistence

The initial domain model includes the following entities.

| Entity        | Purpose                                                     |
| ------------- | ----------------------------------------------------------- |
| Category      | Organizes products into categories                          |
| Product       | Stores product details and pricing                          |
| Inventory     | Represents current stock quantities                         |
| StockMovement | Records changes to inventory                                |
| Sale          | Stores sale-level transaction information                   |
| SaleItem      | Stores the individual products and quantities within a sale |

The database schema and repository implementations define the actual persisted structure.

### Historical Sale Information

Sale items can retain the selling price and cost price applicable at the time of a transaction. Keeping these values with the sale item allows historical sales and gross-profit calculations to use the transaction's recorded prices rather than later product-price changes.

### Tax Configuration

The tax used by the application should be treated as a configurable application value. The prototype should not be interpreted as establishing the legally applicable tax rate for a particular jurisdiction.

### Local Database

The application uses SQLite rather than a hosted cloud database in the current version.

The database file is application data, not merely disposable test output. Preserve it and back it up before performing operations that may modify or replace its contents.

## 14. Project Structure

The project uses a Dart package structure. The exact directory contents should be confirmed against the checked-out repository.

The principal areas are:

```text
shopflow/
|
|-- bin/
|   `-- shopflow.dart
|
|-- lib/
|   |-- models/
|   |-- repositories/
|   |-- services/
|   `-- database/
|
|-- test/
|
|-- pubspec.yaml
|-- analysis_options.yaml
|-- README.md
|-- CONTRIBUTING.md
`-- CHANGELOG.md
```

### Directory Responsibilities

**`bin/`**

Contains the executable entry point for the console application.

**`lib/models/`**

Contains domain models representing business entities.

**`lib/repositories/`**

Contains data-access components for supported entities and workflows.

**`lib/services/`**

Contains application services and business logic.

**`lib/database/`**

Contains database-related infrastructure.

**`test/`**

Contains automated tests.

**`pubspec.yaml`**

Defines the package metadata, SDK constraints, dependencies, and development dependencies.

**`analysis_options.yaml`**

Defines the Dart analysis configuration.

**`README.md`**

Provides project information and usage instructions.

**`CONTRIBUTING.md`**

Describes development practices and contribution procedures.

## 15. Testing Strategy

Testing focuses on meaningful application behavior rather than implementation details alone.

Relevant test areas include:

* Creating valid categories.
* Rejecting invalid category data.
* Creating products with valid information.
* Rejecting invalid product information.
* Preventing sales of inactive products.
* Preventing sales that exceed available stock.
* Calculating sale subtotals.
* Calculating configured taxes.
* Calculating sale totals.
* Validating payment.
* Updating inventory after a sale.
* Recording stock movements.
* Generating business reports.
* Preserving expected behavior when an operation fails.

The automated test suite should be run whenever application behavior changes.

Manual testing should also be used to verify important end-to-end workflows through the console interface.

## 16. Database Safety

Because ShopFlow stores data in SQLite, developers should treat database operations carefully.

Before testing or changing database-related functionality:

1. Identify the database file used by the application.
2. Back up any data that must be preserved.
3. Understand whether the operation inserts, updates, deletes, or replaces data.
4. Avoid running destructive operations against a database containing important records.
5. Use appropriate test data when performing repeatable manual checks.

Do not assume that deleting the database is a safe way to resolve application errors.

Database schema changes should be reviewed carefully to avoid breaking existing data or application behavior.

## 17. Current Limitations

ShopFlow is a local console prototype rather than a complete commercial retail platform.

The current version does not provide the full set of features required for a production business management system.

In particular:

* It does not provide a Flutter mobile interface.
* It does not provide a hosted backend or cloud database.
* It does not implement the deferred supplier, purchase, customer, or employee modules.
* It does not provide online ordering or delivery management.
* It does not provide a complete authentication and authorization system.
* It does not provide multi-branch management, payroll, or full accounting functionality.
* Its reporting capabilities are limited to the implemented basic reports.

Production deployment would require additional requirements analysis, security design, operational testing, data-management planning, and other work beyond the current assignment scope.

## 18. Future Development

Potential future development may include:

* Expanded purchasing and supplier workflows.
* Customer and employee management.
* Authentication and authorization.
* A Flutter application.
* A backend API.
* Cloud-hosted PostgreSQL through Supabase.
* Additional reporting and business analytics.

These are possible future directions, not claims about features already delivered in Version 0.1.

Any expansion should preserve the separation between the interface, application services, repositories, and persistence.

## 19. Contributing

Contributions should follow the project's established engineering principles.

Before making changes:

1. Read `CONTRIBUTING.md`.
2. Understand the current architecture.
3. Review existing code and tests.
4. Make focused changes.
5. Run static analysis and automated tests.
6. Protect existing database data.
7. Update documentation when necessary.

For substantial changes to business rules, database structure, or project scope, discuss the proposed approach with the project maintainer first.

## 20. Project Team

ShopFlow is developed as a group project by a team of five members:

| # | Name | Role / Responsibility | GitHub |
|---|------|-----------------------|--------|
| 1 | Member Name | e.g. Categories and products | [@username](https://github.com/username) |
| 2 | Member Name | e.g. Inventory and stock movements | [@username](https://github.com/username) |
| 3 | Sharon Mary Koroma | e.g. Point of Sale and sales records | [@Ramthasharon(https://github.com/username) |
| 4 | Member Name | e.g. Reports and CLI | [@username](https://github.com/username) |
| 5 | Member Name | e.g. Database layer and testing | [@username](https://github.com/username) |


21. License
No license is specified in this README.

Unless a license is added to the repository, do not assume that the project has been released under an open-source license or that unrestricted reuse and redistribution are permitted.

---

**ShopFlow — Small Business Management System**

Built with Dart and SQLite as an incremental software-engineering project.
