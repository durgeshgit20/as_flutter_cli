# Feature Monorepo Skeleton

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

A Mason brick for generating a feature module skeleton in a Flutter monorepo architecture.

## Overview

This brick creates a standardized structure for feature modules within a Flutter monorepo. It sets up a clean, modular architecture that promotes separation of concerns, testability, and scalability.

## Features

- Clean Architecture structure
- Modular design for encapsulating feature-specific functionality
- Pre-configured for dependency injection
- Structured for easy unit and integration testing
- Scalable design to accommodate growing feature complexity

## Usage

1. Ensure you have Mason installed: `dart pub global activate mason_cli`
2. Add this brick to your Mason configuration:

   ```bash
   mason add feature_monorepo_skeleton
   ```

3. Generate a new feature module:

   ```bash
   mason make feature_monorepo_skeleton --feature_name your_feature_name --app_name your_app_name
   ```

## Generated Structure

```ascii
lib/
├── src/
│ ├── data/
│ │ ├── datasources/
│ │ ├── models/
│ │ └── repositories/
│ ├── domain/
│ │ ├── entities/
│ │ ├── repositories/
│ │ └── usecases/
│ ├── presentation/
│ │ ├── bloc/
│ │ ├── pages/
│ │ └── widgets/
│ └── di/
└── {{feature_name.snakeCase()}}.dart
```

## Best Practices

- Keep layers separated and use dependency injection
- Implement repository interfaces in the data layer
- Use BLoC\Cubit for state management in the presentation layer
- Write unit tests for your use cases and repositories

Happy coding!
