import 'dart:io';

import 'package:fquick_cli/bundle/feature_monorepo_skeleton_bundle.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

/// {@template generate_feature_skeleton_command}
/// `archipelago generate-feature-skeleton`
/// A [Command] to generate a feature skeleton using Mason
/// {@endtemplate}
class GenerateFeatureSkeletonCommand extends Command<int> {
  /// {@macro generate_feature_skeleton_command}
  GenerateFeatureSkeletonCommand({
    required Logger logger,
  }) : _logger = logger;

  @override
  String get description => 'Generate a feature skeleton for a specific app '
      'using `feature_monorepo_skeleton` brick by Banua Coder.';

  @override
  String get name => 'generate-feature-skeleton';

  final Logger _logger;

  @override
  Future<int> run() async {
    final featureName = _logger.prompt(
      'What is the name of your feature module?',
      defaultValue: 'FeatureName',
    );

    final includeGenerated = _logger.confirm(
      'Include generated files in version control?',
    );

    try {
      var vars = <String, dynamic>{
        'featureName': featureName,
        'includeGenerated': includeGenerated,
      };

      // Create a generator
      final generator = await MasonGenerator.fromBundle(
        featureMonorepoSkeletonBundle,
      );

      // Generate files from the brick
      await generator.hooks.compile();

      await generator.hooks.preGen(
        vars: vars,
        onVarsChanged: (updatedVars) => vars = updatedVars,
      );

      await generator.generate(
        DirectoryGeneratorTarget(Directory('.')),
        vars: vars,
      );
      await generator.hooks.postGen(
        vars: vars,
      );

      _logger.success(
        'Feature skeleton for ${vars['appName']} generated successfully!',
      );
      return ExitCode.success.code;
    } catch (e) {
      _logger.err('Failed to generate feature skeleton: $e');
      return ExitCode.software.code;
    }
  }
}
