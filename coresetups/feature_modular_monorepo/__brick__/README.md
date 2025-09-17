# {{appName.titleCase()}} - Flutter Modular Monorepo

## Overview

This is a Flutter modular monorepo project for {{appName.titleCase()}}. It's designed to provide a scalable and maintainable structure for developing complex Flutter applications.

## Project Structure

The project is organized into the following main directories:

- `app/`: Contains the main application module.
- `core/`: Houses core functionalities and utilities shared across the project.
- `features/`: Includes feature-specific modules.
- `packages/`: Contains shared packages, including the UI kit.
- `shared/`: Holds shared resources such as configurations, dependencies, and localization.

## Getting Started

1. Ensure you have Flutter (SDK version >=3.2.4 <4.0.0) installed on your system.
2. Install FlutterGen: `dart pub global activate flutter_gen`
3. Clone this repository.
4. Run `flutter pub get` in the root directory to fetch all dependencies.
5. Use Melos to manage the monorepo:
   - Install Melos: `dart pub global activate melos`
   - Run `melos bootstrap` to set up the workspace.


## Custom Melos Scripts

This project utilizes custom Melos scripts to streamline development workflows across all packages and modules. These scripts allow you to run common Dart and Flutter commands across the entire monorepo without manually executing them in each package directory.

Here are some useful custom Melos scripts:

### Code Analysis

- Run static analysis on all Flutter packages:
  ```
  melos analyze
  ```

- Run static analysis on selected Flutter packages with a test directory:
  ```
  melos run analyze:select
  ```

### Code Generation

- Generate environment-specific code for packages using envied_generator:
  ```
  melos run generate-env
  ```

- Generate localization files from JSON for packages using slang and slang_flutter:
  ```
  melos run generate-locale
  ```

- Generate asset classes for the UI Kit Package using FlutterGen:
  ```
  melos run generate-assets
  ```

### Build Runner Commands

- Generate code for the main app:
  ```
  melos run build-app
  ```

- Generate code for Widgetbook:
  ```
  melos run build-widgetbook
  ```

- Generate code for the core package:
  ```
  melos run build-core
  ```

- Run build_runner for all eligible packages:
  ```
  melos build
  ```

- Clean generated files in all packages that use build_runner:
  ```
  melos run build:clean
  ```

### Dependency Management

- Get dependencies for all Flutter packages:
  ```
  melos get
  ```

- Upgrade dependencies for all Flutter packages:
  ```
  melos upgrade
  ```

### Code Fixes

- Apply automated fixes to Dart code in all Flutter packages:
  ```
  melos fix
  ```

### Testing

- Run all tests in the project with optimizations and coverage:
  ```
  melos test
  ```

- Generate test coverage for all packages with tests:
  ```
  melos coverage
  ```

### Project Initialization

- Set up the entire project by running all necessary code generation and build steps:
  ```
  melos run initialize-app
  ```

These custom scripts significantly simplify the development process in a modular monorepo structure, ensuring consistency and efficiency across all packages and modules. Each script can be run using `melos run <script-name>` or, in some cases, just `melos <script-name>`.

## Development

- Use the modular structure to organize your code.
- Leverage the shared packages and core module for common functionalities.
- Follow the established coding standards and architecture patterns.

## Building and Running

This project uses flavors for different build configurations. To run the main application:

1. Navigate to `app/{{appName.snakeCase()}}/`
2. Run the app with a specific flavor:
   - For development: `flutter run --flavor dev -t lib/main_dev.dart`
   - For staging: `flutter run --flavor staging -t lib/main_staging.dart`
   - For production: `flutter run --flavor prod -t lib/main_prod.dart`

Note: Simply running `flutter run` without specifying a flavor will not work.

This project comes with predefined configurations for Visual Studio Code and IntelliJ IDEA, making it easier to set up your development environment:

- For Visual Studio Code: Open the project folder in VS Code, and it will automatically load the workspace settings and recommended extensions. Use the provided launch configurations to run the app with different flavors.
- For IntelliJ IDEA: Open the project in IDEA, and it will recognize the project structure and configurations automatically. Use the predefined run configurations to launch the app with specific flavors.

These predefined settings ensure consistent code formatting, linting, and debugging experiences across different development environments, as well as proper handling of flavors.

## Testing

Each module and feature in this monorepo has its own set of tests. To run tests and generate coverage reports:

1. Ensure you're in the root directory of the monorepo.
2. Use the following Melos commands:

### Running Tests

- Run all tests in the project:
  ```
  melos test
  ```

- Run tests for selected packages:
  ```
  melos run test:select
  ```

### Generating Coverage

- Generate LCOV coverage for all packages:
  ```
  melos run test:with-lcov-coverage
  ```

- Generate LCOV and HTML coverage reports:
  ```
  melos run test:with-html-coverage
  ```

- Generate coverage reports and automatically open the HTML report:
  ```
  melos run test:with-html-coverage:all:auto-open
  ```

After running the HTML coverage command, you can find the report at:
```
MELOS_ROOT_PATH/coverage_report/index.html
```

### Additional Test Commands

- Update golden test files:
  ```
  melos run update-goldens
  ```

These commands leverage Melos to efficiently run tests and generate coverage reports across the entire monorepo. They exclude certain packages (like l10n and config) and focus on packages with a test directory.

For running tests in specific modules or features, you can still navigate to the respective directory and use standard Flutter test commands.

## Dependencies

Key dependencies include:

- Flutter SDK
- Melos for monorepo management
- Shared dependencies in `shared/dependencies`
- Various module-specific dependencies (refer to individual `pubspec.yaml` files)

For a comprehensive list of shared dependencies, check the `pubspec.yaml` file in the `shared/dependencies` directory. These global dependencies are available to all modules in the monorepo.

## Contributing

Please read the CONTRIBUTING.md file for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the [Your License] - see the LICENSE.md file for details.
