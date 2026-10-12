# Contributing to ShopFlow

Thank you for your interest in contributing to ShopFlow.

ShopFlow is a Dart-based small business management prototype that uses SQLite for local persistence. This document describes how to set up the development environment, run the application, verify changes, and follow the project's engineering practices.

The goal is to maintain a codebase that is understandable, testable, reliable, and suitable for incremental development.

---

## 1. Project Overview

ShopFlow currently focuses on:

* Category management.
* Product management.
* Inventory tracking.
* Stock movements.
* Point of Sale.
* Sales records.
* Basic business reports.
* SQLite persistence.
* A Dart console interface.
* Automated testing.

Features such as Flutter, online ordering, delivery management, supplier and purchase management, customer and employee management, cloud services, and advanced authentication are outside the initial version's scope unless the project maintainer explicitly approves a change.

Before contributing, review `README.md` to understand the current functionality and limitations.

## 2. Prerequisites

Install the following tools:

* Git.
* A Dart SDK compatible with the project's `pubspec.yaml`.
* A terminal or command-line environment.
* A code editor, such as Visual Studio Code, if desired.

The current package configuration specifies a Dart SDK constraint of `^3.13.4`.

Verify that Git and Dart are available:

```bash
git --version
dart --version
```

If the `dart` command is not recognized, install a compatible SDK and configure the system's `PATH` to include the SDK's `bin` directory.

Open a new terminal after changing environment variables.

## 3. Clone the Repository

Clone the project:

```bash
git clone https://github.com/QuantumCodr/shopflow-engineering-project-2026.git
```

Enter the repository:

```bash
cd shopflow-engineering-project-2026
```

Confirm that you are in the project root, where `pubspec.yaml` is located.

If the repository is already cloned, do not clone it again inside the existing project directory.

## 4. Update an Existing Clone

To obtain the latest changes from the remote `main` branch:

```bash
git switch main
git pull origin main
dart pub get
```

Before switching branches or pulling changes, inspect your working tree:

```bash
git status
```

Preserve any local work that has not been committed. Do not discard changes simply to make the working tree clean.

## 5. Install Dependencies

From the repository root, run:

```bash
dart pub get
```

This resolves the dependencies declared in `pubspec.yaml`.

If dependency resolution fails:

1. Read the complete error message.
2. Verify the installed Dart SDK version.
3. Inspect the relevant dependency constraints.
4. Determine whether the problem is caused by the environment or the project configuration.
5. Avoid changing dependency versions without understanding the consequences.

Do not remove project dependencies simply to bypass a resolution error.

## 6. Run the Application

Start ShopFlow from the repository root:

```bash
dart run bin/shopflow.dart
```

Follow the console prompts to interact with the available functionality.

The current application is a Dart console program. It is not a Flutter application or a hosted web service.

### Database Caution

ShopFlow uses SQLite for local persistence.

Before testing operations that modify data:

1. Identify the actual database path used by the application.
2. Back up important existing records.
3. Understand whether the test will insert, update, or delete data.
4. Avoid destructive tests against a database containing records that must be preserved.

Do not delete, reset, or replace the existing database as a routine troubleshooting step.

## 7. Run Static Analysis

From the repository root, run:

```bash
dart analyze
```

Review the analyzer output.

Resolve new issues introduced by your changes. If an existing issue is unrelated to the contribution, document it rather than hiding it through an unrelated refactor.

Do not disable analysis rules merely to make the command pass.

## 8. Run Automated Tests

Run the full test suite:

```bash
dart test
```

Wait for the command to finish and inspect its exit status and output.

A successful test run is required before a change is considered ready for review, unless the maintainer has agreed to a specific exception.

When tests fail:

1. Identify the failing test.
2. Determine whether the failure is caused by the change, the existing code, or the environment.
3. Reproduce the failure where possible.
4. Fix the underlying problem.
5. Rerun the affected tests.
6. Rerun the full suite before submitting.

Do not claim that tests pass unless you have actually run them and observed a successful result.

## 9. Engineering Principles

Contributions should follow these principles.

### 9.1 Build Incrementally

Make small, coherent changes that can be reviewed and tested independently.

Avoid combining unrelated features, broad refactoring, and formatting changes in one contribution.

### 9.2 Preserve the Layered Architecture

The intended architecture is:

```text
CLI
 |
 v
Services
 |
 v
Repositories
 |
 v
SQLite
```

Each layer has a clear responsibility.

### 9.3 Keep the CLI Thin

The CLI should handle:

* Input collection.
* Output presentation.
* Menu navigation.
* Calling application services.
* Basic interaction flow.

Core business rules should not be implemented primarily inside the CLI.

### 9.4 Keep Business Rules in Services

Services should own relevant application behavior, including:

* Validation.
* Calculations.
* Business constraints.
* Application workflows.
* Coordination between repositories.

Avoid duplicating the same business rules across different interfaces or layers.

### 9.5 Keep Repositories Focused on Data Access

Repositories should handle database access and persistence.

Avoid moving application-level decisions into repository implementations or SQL statements when those decisions belong in services.

### 9.6 Maintain Clear Domain Models

Domain models should represent the business concepts they are responsible for.

Do not introduce extra fields, entities, or abstractions without a clear requirement and architectural benefit.

### 9.7 Avoid Premature Complexity

Prefer the simplest implementation that correctly satisfies the requirement.

Do not introduce frameworks, layers, or dependencies merely because they may be useful in a much larger future system.

### 9.8 Preserve Existing Behavior

Understand the dependencies and current behavior before modifying existing components.

A change should not silently break another module, alter a public service contract, or change existing database behavior.

If behavior must change, explain why and update the relevant tests and documentation.

## 10. Recommended Feature Development Workflow

For a new or modified feature, use the following workflow where applicable:

```text
Requirement
    |
    v
Review Existing Design
    |
    v
Model
    |
    v
Repository
    |
    v
Service
    |
    v
Service-Level Tests
    |
    v
CLI Integration
    |
    v
Manual Verification
    |
    v
Documentation
    |
    v
Freeze and Commit
```

Not every change requires modifications to every layer. Avoid unnecessary changes when an existing layer already supports the requirement.

### Step 1: Understand the Requirement

Clarify the intended behavior, validation rules, expected results, and relevant failure cases.

Review the existing implementation before designing a replacement.

### Step 2: Review Dependencies

Determine which models, services, repositories, database operations, CLI menus, and tests depend on the affected functionality.

Consider whether the change could affect existing records or other workflows.

### Step 3: Update the Model When Necessary

Modify domain models only when the requirement calls for a change to the represented data or behavior.

Consider compatibility with existing data and serialization or mapping code.

### Step 4: Update the Repository When Necessary

Implement the required persistence behavior while keeping repository responsibilities focused on data access.

Preserve existing records unless the requirement explicitly calls for a data change.

### Step 5: Implement the Service Logic

Implement validation, calculations, and business workflows in the appropriate service.

Handle expected invalid inputs and failure cases consistently.

### Step 6: Test Service Behavior

Write or update tests that verify the behavior visible to the rest of the application.

Cover important success cases, invalid inputs, boundaries, and failure paths.

Prefer service-level behavior tests that exercise the repository through the service rather than creating separate repository tests by default.

Separate repository tests may be appropriate when specifically justified by a complex persistence behavior.

### Step 7: Integrate the CLI

Update the console interface to collect the required input, invoke the service, and present understandable results.

Keep business decisions out of the interface.

### Step 8: Verify the Feature

Run:

```bash
dart analyze
dart test
```

Manually exercise the relevant workflow through the CLI when appropriate.

Check that invalid operations are handled correctly and that related data remains consistent.

### Step 9: Update Documentation

Update `README.md`, usage instructions, or other relevant documentation when a change affects the project's behavior, setup, architecture, or limitations.

### Step 10: Freeze the Feature

Once the implementation is verified, avoid unrelated changes to the completed feature.

If a later requirement exposes a defect, address it through a focused change with appropriate tests.

## 11. Database and Transaction Safety

Database changes require particular care because the application stores persistent information.

Before modifying database-related functionality:

* Identify the existing schema and database path.
* Review the affected repository and database initialization code.
* Determine whether existing data must be migrated.
* Back up data before testing changes that could affect it.
* Consider transaction boundaries for workflows that update multiple related records.
* Verify failure behavior as well as successful operations.

### Sale Workflow

The sale workflow may involve several related operations:

1. Validate the sale.
2. Validate the requested products and quantities.
3. Verify stock availability.
4. Calculate the amounts.
5. Validate payment.
6. Save the sale.
7. Save the sale items.
8. Update inventory.
9. Record stock movements.

Where the implementation uses a transaction, related changes should succeed or fail together.

Changes to sale processing must not introduce a situation in which the sale is saved but the corresponding inventory changes are missing, or vice versa.

### Destructive Operations

Do not introduce automatic database deletion, resets, or replacement behavior without a clearly justified requirement and explicit review.

Never commit a personal database copy containing data that should remain local.

## 12. Testing Guidelines

Tests should verify meaningful application behavior.

Depending on the feature, consider the following cases:

* Valid input.
* Missing or invalid input.
* Invalid numeric values.
* Boundary values.
* Duplicate or conflicting data.
* Inactive products.
* Insufficient inventory.
* Insufficient payment.
* Correct calculations.
* Correct persistence.
* Correct inventory updates.
* Correct stock movements.
* Correct report results.
* Expected behavior when an operation fails.

Tests should be understandable, repeatable, and independent of undocumented assumptions.

Avoid writing tests that only reproduce the internal implementation without checking the behavior the application is supposed to provide.

## 13. Git Workflow

Use Git to keep changes focused and traceable.

### Step 1: Update the Main Branch

```bash
git switch main
git pull origin main
```

### Step 2: Create a Feature Branch

Use a descriptive branch name:

```bash
git switch -c feat/short-description
```

For a bug fix, a name such as the following may be appropriate:

```bash
git switch -c fix/short-description
```

### Step 3: Make the Change

Modify only the files needed for the requirement.

Inspect the working tree:

```bash
git status
```

Review the changes:

```bash
git diff
```

### Step 4: Verify the Change

Run:

```bash
dart analyze
dart test
```

Perform manual verification where appropriate.

### Step 5: Stage Specific Files

Stage only the files intended for the contribution:

```bash
git add path/to/file.dart
```

For multiple files, specify each intended path or use another carefully reviewed staging command.

Avoid automatically staging unrelated files or local database changes.

### Step 6: Commit the Change

Use a clear commit message:

```bash
git commit -m "feat: describe the change"
```

Other useful prefixes may include:

* `fix:` for a bug fix.
* `docs:` for documentation.
* `test:` for test changes.
* `refactor:` for a behavior-preserving code refactor.

Choose a message that accurately describes the change.

### Step 7: Push the Branch

```bash
git push -u origin feat/short-description
```

Replace the branch name with the branch you actually created.

### Step 8: Open a Pull Request

When collaboration is being used, open a pull request describing:

* The problem being addressed.
* The change made.
* The tests executed.
* Any relevant manual verification.
* Any known limitations or follow-up work.

If the project is being maintained by one developer, the same workflow can still be used to keep changes organized.

## 14. Pull Request Checklist

Before submitting a change, verify the following:

* [ ] The change addresses a clear requirement.
* [ ] Existing behavior has been reviewed.
* [ ] Dependencies and affected layers have been considered.
* [ ] Business rules remain in the appropriate services.
* [ ] Repositories remain focused on persistence.
* [ ] Validation and failure cases have been considered.
* [ ] Relevant tests have been added or updated.
* [ ] `dart analyze` has been executed.
* [ ] `dart test` has been executed.
* [ ] Manual verification has been performed where appropriate.
* [ ] Database data has been protected.
* [ ] Documentation has been updated where necessary.
* [ ] No secrets or unintended files are included.
* [ ] The changes have been reviewed with `git diff`.
* [ ] The commit message accurately describes the change.

## 15. Dependencies and Configuration

Before adding a dependency, consider:

* Whether the requirement can be met using existing dependencies.
* Whether the dependency is compatible with the project's Dart SDK constraint.
* Whether it introduces unnecessary complexity.
* Whether it affects application startup, persistence, or testing.
* Whether the dependency and its purpose should be documented.

Update `pubspec.yaml` deliberately and resolve dependencies before verifying the application.

Do not introduce a dependency solely for a feature that is outside the current project scope.

## 16. Security and Sensitive Information

Do not commit:

* Passwords.
* API keys.
* Access tokens.
* Private credentials.
* Personal secrets.
* Local configuration containing sensitive information.
* Database records that should not be shared.

If a future feature introduces authentication, remote services, or external configuration, its security requirements should be reviewed before implementation.

The current prototype should not be represented as a production-secure, cloud-hosted system.

## 17. Scope and Architecture Changes

Discuss substantial changes with the project maintainer before implementation.

This includes changes to:

* Database schema.
* Core domain models.
* Service contracts.
* Layer boundaries.
* Sale and inventory workflows.
* Dependency strategy.
* Project scope.
* Persistent data behavior.

Prefer extending the existing architecture rather than replacing working components without a clear reason.

A future feature should not be treated as implemented merely because it appears in a roadmap or project proposal.

## 18. Documentation Standards

Documentation should accurately describe the current codebase.

When documenting a feature:

* Explain what the feature currently does.
* Identify important limitations.
* Include the relevant command or workflow where useful.
* Avoid claiming that unimplemented functionality is complete.
* Keep setup instructions consistent with `pubspec.yaml` and the actual entry point.
* Update instructions when commands or project structure change.

When reporting test results, use results obtained from the version being documented.

## 19. Questions and Maintenance

For questions involving architecture, database changes, major business rules, or expansion beyond the initial scope, consult the project maintainer before proceeding.

When a problem is discovered:

1. Describe the observed behavior.
2. Explain the expected behavior.
3. Provide steps to reproduce it where possible.
4. Include relevant error messages or test results.
5. Identify any known impact on existing data or functionality.

This helps keep debugging and development focused.

---

## Final Principle

**Build a small, complete, understandable, and tested system before expanding its scope.**

ShopFlow should evolve through verified improvements, clear responsibilities, careful data management, and documentation that accurately reflects the implementation.

**Project:** ShopFlow — Small Business Management System
**Language:** Dart
**Database:** SQLite
**Repository:** https://github.com/QuantumCodr/shopflow-engineering-project-2026
