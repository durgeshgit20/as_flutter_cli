# Shared Dependencies Package

This package manages shared dependencies across all projects within this Flutter monorepo. By centralizing our dependencies here, we ensure consistency, reduce duplication, and simplify the process of updating packages across our projects.

## Getting Started

This README outlines the guidelines for adding, updating, and using shared dependencies within our monorepo.

### Prerequisites

- Flutter SDK: Ensure you have the latest version of Flutter installed. Visit [Flutter's official website](https://flutter.dev/docs/get-started/install) for installation instructions.
- Melos: This monorepo uses [Melos](https://pub.dev/packages/melos) to manage project workflows. If you haven't installed Melos, you can do so by running `dart pub global activate melos`.

### Adding a New Shared Dependency

To add a new shared dependency to our monorepo, follow these steps:

1. **Add the Package**: Navigate to the root of the dependencies package and run the command to add a new package. For example, to add `get_it` as a shared dependency, you would run:

   ```sh
   flutter pub add get_it
   ```

2. **Export the Package**: After adding the package, export it in the `dependencies.dart` file located at the root of the dependencies package. This makes the dependency available to other projects within the monorepo.

   ```dart
   export 'package:get_it/get_it.dart';
   ```

3. **Synchronize the Dependencies**: Use Melos to synchronize the newly added dependency across the monorepo. Run:

   ```sh
   melos get
   ```

### Using Shared Dependencies

To use the shared dependencies in your project, simply import the `dependencies.dart` file from the dependencies package. For example:

```dart
import 'package:dependencies/dependencies.dart';

```
