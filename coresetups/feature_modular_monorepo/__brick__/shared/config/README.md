# Config Package

The Config Package is an essential part of our Flutter app architecture, designed to define and manage app flavors and environment variables efficiently. This package uses Envied for environment variable management, ensuring type-safe access to these variables throughout the app. By default, the package supports three flavors: `development`, `staging`, and `production`, each corresponding to its environment class: `EnvDev`, `EnvStg`, and `EnvProd`.

## Getting Started

This section outlines the structure and usage of the Config Package, including setting up flavors and managing environment variables.

### Flavors

The package defines app flavors using a `Flavor` class, which holds a static variable `flavorStatus` of type `FlavorStatus` enum. This enum can be set during app initialization to specify the current app flavor.

For example, to set the app flavor to development at initialization, use the following code in `main_dev.dart`:

```dart
Flavor.flavorStatus = FlavorStatus.development;
```

### Environment Variables

Environment variables are defined using Envied and are accessed in a type-safe manner. The package utilizes an `Env` class, which serves as an env_reader utility to map environment variables based on the current app flavor.

#### Adding a New Environment Variable

To add a new environment variable:

1. Define the variable in your `.env` file(s) following the Envied documentation.
2. Use the Envied package to generate type-safe code for accessing the environment variable.

#### Important: Regenerating Environment Variables

After adding or updating environment variables, run the following command to re-generate the environment variable code:

```sh
melos generate-env
```

This ensures that your changes are reflected in the generated code, allowing for type-safe access to the updated variables.

### Usage

To utilize an environment variable in your app, access it through the generated `Env` class. This class abstracts away the complexity of reading environment variables directly, providing a simple and type-safe way to access them based on the current flavor.

## Conclusion

The Config Package streamlines the management of app flavors and environment variables, promoting a clean and maintainable codebase. By following the guidelines outlined in this README, you can efficiently manage different app configurations and environment-specific variables, enhancing your app's scalability and flexibility.

For more detailed information on using Envied, refer to the [Envied documentation](https://pub.dev/packages/envied).
