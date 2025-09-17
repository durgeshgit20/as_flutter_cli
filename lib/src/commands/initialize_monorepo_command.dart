import 'dart:io';

import 'package:fquick_cli/bundle/flutter_modular_monorepo_bundle.dart';
import 'package:fquick_cli/src/domain/domain.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart';

/// {@template initialize_monorepo_command}
/// `archipelago initialize-monorepo`
/// A [Command] to initialize a Flutter modular monorepo using Mason
/// {@endtemplate}
class InitializeMonorepoCommand extends Command<int> {
  /// {@macro initialize_monorepo_command}
  InitializeMonorepoCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser.addOption(
      'output-dir',
      abbr: 'o',
      help: 'The directory where the monorepo will be initialized',
      defaultsTo: '.',
    );
  }

  @override
  String get description => 'Initialize a Flutter modular monorepo with'
      ' `flutter_modular_monorepo` brick by Banua Coder.';

  @override
  String get name => 'initialize-monorepo';

  final Logger _logger;

  @override
  Future<int> run() async {
    var outputDir = argResults?['output-dir'] as String? ?? '.';

    if (outputDir == '.') {
      final confirmCreation = _logger.confirm(
        'Do you want to initalize the monorepo in the current directory?',
      );

      if (!confirmCreation) {
        outputDir = _logger.prompt(
          'Where do you want to initialize the monorepo?',
          defaultValue: '.',
        );
      }
    }

    if (outputDir != '.') {
      outputDir = join(Directory.current.path, outputDir);
    }

    final melosPath = join(outputDir, 'melos.yaml');

    final melosFileExists = File(melosPath).existsSync();

    if (melosFileExists) {
      _logger.err('You can only initialize a monorepo in an empty directory.');
      return ExitCode.cantCreate.code;
    }

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

    final networkingLibraries = ['dio', 'http'];

    final selectedNetworkingLibraries = _logger.chooseOne<String>(
      'Which network library do you want to use?',
      choices: networkingLibraries,
      defaultValue: 'dio',
    );

    final includeGenerated = _logger.confirm(
      'Should generated files be included in Git version control? (yes/no)',
    );

    final useFirebase = _logger.confirm(
      'Is this project use firebase? (yes/no)',
    );

    var firebaseIDProd = '';
    var firebaseIDStg = '';
    var firebaseIDDev = '';

    if (useFirebase) {
      firebaseIDDev = _logger.prompt(
        'Enter Firebase APP ID for Development flavor: ',
      );

      firebaseIDStg = _logger.prompt(
        'Enter Firebase APP ID for Staging flavor: ',
      );

      firebaseIDProd = _logger.prompt(
        'Enter Firebase APP ID for Production flavor: ',
      );
    }

    _logger.info('Initializing Flutter modular monorepo in $outputDir...');

    try {
      var vars = <String, dynamic>{
        'appName': appName,
        'organization': organization,
        'domain': domain,
        'prefix': appNamePrefix,
        'prefixCasing': selectedCasingStrategy.name,
        'networkLibrary': selectedNetworkingLibraries,
        'includeGenerated': includeGenerated,
        'isUsingFirebase': useFirebase,
        'firebaseProjectDev': firebaseIDDev,
        'firebaseProjectStg': firebaseIDStg,
        'firebaseProject': firebaseIDProd,
      };

      // Create a generator
      final generator = await MasonGenerator.fromBundle(
        flutterModularMonorepoBundle,
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
        workingDirectory: outputDir,
        vars: vars,
      );

      _logger.success('Flutter modular monorepo initialized successfully!');
      return ExitCode.success.code;
    } catch (e) {
      _logger.err('Failed to initialize monorepo: $e');
      return ExitCode.software.code;
    }
  }
}
