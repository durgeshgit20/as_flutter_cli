# {{feature_name.titleCase()}} Feature Module

## Overview

This brick generates a feature module for the {{feature_name.titleCase()}} feature in our Flutter monorepo architecture. It sets up a clean, modular structure that promotes separation of concerns and maintainability.

## Key Benefits

- **Clean Architecture**: Follows best practices for scalable Flutter apps
- **Modularity**: Encapsulates all {{feature_name.titleCase()}}-related functionality
- **Testability**: Structured for easy unit and integration testing
- **Scalability**: Designed to grow with your feature's complexity

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

## Usage

1. Run the brick with your desired feature name
2. Implement your feature logic within the generated structure
3. Use `{{feature_name.snakeCase()}}.dart` to export public APIs

## Best Practices

- Keep layers separated and use dependency injection
- Implement repository interfaces in the data layer
- Use BLoC\Cubit for state management in the presentation layer
- Write unit tests for your use cases and repositories

Happy coding!
