import 'dart:io';

import 'package:archipelago_cli/bundle/flutter_l10n_package_bundle.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart';

/// {@template generate_localization_package_command}
/// `archipelago generate-localization-package`
/// A [Command] to generate a localization package using Mason
/// {@endtemplate}
class GenerateLocalizationPackageCommand extends Command<int> {
  /// {@macro generate_localization_package_command}
  GenerateLocalizationPackageCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser.addOption(
      'output-dir',
      abbr: 'o',
      help: 'The directory where the localization package will be generated',
      defaultsTo: '.',
    );
  }

  @override
  String get description => 'Generate a localization package using '
      '`flutter_l10n_package` brick by Banua Coder.';

  @override
  String get name => 'generate-localization-package';

  final Logger _logger;

  @override
  Future<int> run() async {
    var outputDir = argResults?['output-dir'] as String? ?? '.';

    if (outputDir == '.') {
      final confirmCreation = _logger.confirm(
        'Do you want to generate the localization package in the current '
        'directory?',
      );

      if (!confirmCreation) {
        outputDir = _logger.prompt(
          'Where do you want to generate the localization package?',
          defaultValue: '.',
        );
      }
    }

    if (outputDir != '.') {
      outputDir = join(Directory.current.path, outputDir);
    }

    _logger.info('outputDir: $outputDir');

    final appName = _logger.prompt(
      'What is the name of your application?',
      defaultValue: 'MyApp',
    );

    final isForMonorepo = _logger.confirm(
      'Are you generating this package for a monorepo project?',
    );

    final includeGenerated = _logger.confirm(
      'Include generated files in version control?',
    );

    try {
      var vars = <String, dynamic>{
        'appName': appName,
        'isForMonorepo': isForMonorepo,
        'includeGenerated': includeGenerated,
      };

      // Create a generator
      final generator = await MasonGenerator.fromBundle(
        flutterL10nPackageBundle,
      );

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
      _logger.err('Failed to generate localization package: $e');
      return ExitCode.software.code;
    }
  }
}
