import 'dart:convert';
import 'dart:io';

import 'package:archipelago_cli/bundle/flutter_ui_kit_bundle.dart';
import 'package:archipelago_cli/src/domain/domain.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart';

/// {@template generate_ui_kit_command}
/// `archipelago generate-ui-kit`
/// A [Command] to generate a UI kit package using Mason
/// {@endtemplate}
class GenerateUIKitCommand extends Command<int> {
  /// {@macro generate_ui_kit_command}
  GenerateUIKitCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser
      ..addOption(
        'output-dir',
        abbr: 'o',
        help: 'The directory where the UI kit will be initialized',
        defaultsTo: '.',
      )
      ..addOption(
        'config',
        abbr: 'c',
        help: 'JSON string containing all required variables',
      );
  }

  @override
  String get description => 'Generate a UI kit package '
      '`flutter_ui_kit` brick by Banua Coder.';

  @override
  String get name => 'generate-ui-kit';

  final Logger _logger;

  @override
  Future<int> run() async {
    var outputDir = argResults?['output-dir'] as String? ?? '.';
    final config = argResults?['config'] as String?;

    Map<String, dynamic> vars;

    if (config != null) {
      vars = _parseConfig(config);
    } else {
      vars = await _promptForVariables(outputDir);
    }

    outputDir = _resolveOutputDir(outputDir);
    _logger.info('Initializing UI Kit in $outputDir...');

    try {
      // Create a generator
      final generator = await MasonGenerator.fromBundle(flutterUiKitBundle);

      // Generate files from the brick
      await generator.hooks.compile();

      await generator.hooks.preGen(
        vars: vars,
        onVarsChanged: (updatedVars) => vars = updatedVars,
      );

      await generator.generate(
        DirectoryGeneratorTarget(Directory(outputDir)),
        vars: vars,
      );
      await generator.hooks.postGen(
        vars: vars,
        workingDirectory: outputDir,
      );

      return ExitCode.success.code;
    } catch (e) {
      _logger.err('Failed to generate UI Kit: $e');
      return ExitCode.software.code;
    }
  }

  Map<String, dynamic> _parseConfig(String config) {
    try {
      final parsedJson = json.decode(config) as Map<String, dynamic>;
      final requiredKeys = [
        'appName',
        'organization',
        'domain',
        'prefix',
        'prefixCasing',
        'includeGenerated',
        'isForMonorepo',
      ];

      for (final key in requiredKeys) {
        if (!parsedJson.containsKey(key)) {
          throw FormatException('Missing required key: $key');
        }
      }

      return parsedJson;
    } catch (e) {
      _logger.err('Error parsing JSON input: $e');
      exit(ExitCode.usage.code);
    }
  }

  Future<Map<String, dynamic>> _promptForVariables(String outputDir) async {
    final appName = _logger.prompt(
      'What is the name of your application?',
      defaultValue: 'banua_app',
    );

    final organization = _logger.prompt(
      'What is the name of your organization or company?',
      defaultValue: 'Banua Coder',
    );

    final domain = _logger.prompt(
      "What is your organization's top-level domain?",
      defaultValue: 'com',
    );

    final appNamePrefix = _logger.prompt(
      'What prefix would you like to use for your project components? '
      " (e.g., 'my' for MyButton, MYWidget)",
      defaultValue: appName,
    );

    final casingStrategies = [
      PrefixNamingStrategy.pascalCase,
      PrefixNamingStrategy.upperCase,
    ];

    final selectedCasingStrategy = _logger.chooseOne<PrefixNamingStrategy>(
      'How should the prefix be cased in component names?',
      choices: casingStrategies,
      defaultValue: PrefixNamingStrategy.pascalCase,
      display: (choice) => choice.label,
    );

    final includeGenerated = _logger.confirm(
      'Should generated files be included in Git version control? (yes/no)',
    );

    final isForMonorepo = _logger.confirm(
      'Are you generating this UI Kit for a monorepo project?',
    );

    return {
      'appName': appName,
      'organization': organization,
      'domain': domain,
      'prefix': appNamePrefix,
      'prefixCasing': selectedCasingStrategy.name,
      'includeGenerated': includeGenerated,
      'isForMonorepo': isForMonorepo,
    };
  }

  String _resolveOutputDir(String outputDir) {
    if (outputDir != '.') {
      return join(Directory.current.path, outputDir);
    }
    return outputDir;
  }
}
