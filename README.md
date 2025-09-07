# Archipelago

<div align="center">
<img src="https://i.ibb.co.com/qNRVKCt/archipelago.png" height="520"/>

![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

<!-- ![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg) -->

</div>

## 🏝 About Archipelago

Archipelago is a sophisticated Flutter starter kit designed for scalable applications using a monorepo architecture. Like its namesake—a chain of islands connected by water—Archipelago connects multiple Flutter packages and modules into a cohesive, maintainable ecosystem.

## ✨ Key Features

### 🏗 Monorepo Structure

- **Mason-powered Templates**: Standardized package generation for consistency across your project
- **Melos Workflow**: Streamlined management of multiple packages with efficient versioning and publishing
- **Smart Dependencies**: Optimized internal package dependencies with proper versioning

### 📦 Pre-configured Packages

- **Core Module**: Essential utilities, helpers, and shared functionality
- **UI Kit**: Ready-to-use custom widgets and design system
- **Navigation**: Pre-configured routing system
- **Network**: HTTP client setup with interceptors and error handling
- **State Management**: Scalable state management solution
  <!-- - **Analytics**: Built-in analytics and tracking capabilities -->
  <!-- - **Authentication**: Basic auth flow implementation -->
  <!-- - **Storage**: Local storage and caching solutions -->

### 🛠 Developer Experience

- **Code Generation**: Automated code generation for models, APIs, and more
- **Testing Setup**: Pre-configured unit, widget, and integration testing
- **CI/CD Templates**: Ready-to-use continuous integration and deployment workflows
- **Documentation**: **Coming Soon**
- **Hot Reload Support**: Optimized for Flutter's hot reload across all packages
- **Linting Rules**: Consistent code style enforcement across packages

## 🚀 Getting Started

```bash
# Install archipelago globally
dart pub global activate archipelago_cli

# Initialize Archipelago or
archipelago start

# Setup monorepo workspace
archipelago initialize-monorepo
```

Next, you can run the app by using existing `vscode` or `Android Studio` configuration.

## 📐 Architecture

Archipelago follows a modular architecture pattern:

```ascii
../
├── app/                   # Application projects
│   ├── mobile/            # Main mobile application
│   └── widgetbook/        # Example app showcasing ui kit
├── core/                  # Core utilities and helpers
├── features/              # Feature packages
├── packages/              # Shared packages
│   ├── ui_kit/            # Shared UI components
├── plugins/               # Shared plugins
├── scripts/               # Development tools
├── shared/                # Shared/common config/packages
│   ├── config/             # Shared configuration (env, flavor)
│   ├── dependencies/      # Shared dependencies (blocs, etc.)
│   └── l10n/              # Shared localization package
└── melos.yaml             # Monorepo configuration
```

## 🎯 Use Cases

Archipelago is perfect for:

- 🏢 Enterprise applications requiring scalable architecture
- 🚀 Startups planning to scale their applications
- 👥 Teams working on multiple related Flutter projects
- 🛠 Projects requiring consistent development patterns
- 📱 Applications with multiple flavors or white-label solutions

## 💡 Philosophy

Archipelago embraces these core principles:

- **Modularity**: Independent yet connected packages
- **Scalability**: From small apps to enterprise solutions
- **Maintainability**: Clear structure and patterns
- **Developer Experience**: Efficient workflows and tools
- **Best Practices**: Industry-standard Flutter patterns

<!-- ## 🤝 Contributing

We welcome contributions! See our [Contributing Guide](CONTRIBUTING.md) for details. -->

## 📄 License

Archipelago is available under the MIT License. See the [LICENSE](LICENSE) file for more info.

## 🙋‍♂️ Support

- 📖 Documentation (Coming Soon)
- 💬 [Discord Community](https://discord.gg/2gJes2Xcfx)
- 🐛 [Issue Tracker](https://discord.gg/2gJes2Xcfx)

---

<div align="center">
  
  **Built with ❤️ for the Flutter community**
  
  <!-- [Website](https://archipelago.dev) • [Twitter](https://twitter.com/archipelago_dev) • [Blog](https://blog.archipelago.dev) -->
</div>
