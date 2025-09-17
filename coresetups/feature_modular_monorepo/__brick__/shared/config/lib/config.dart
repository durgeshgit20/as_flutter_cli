/// {@template config}
/// Configuration package for {{appName.titleCase()}}.
/// This package manages environment-specific settings, API endpoints,
/// and other configuration parameters across different build flavors
/// (development, staging, production).
/// {@endtemplate}
library config;

export 'src/flavor.dart';
export 'src/env/env.dart';
