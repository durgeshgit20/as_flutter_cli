import 'dart:io';

import 'package:archipelago_cli/src/commands/commands.dart';
import 'package:archipelago_cli/src/domain/domain.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

/// {@template start_command}
/// `archipelago start`
/// A [Command] to generate a feature skeleton using Mason
/// {@endtemplate}
class StartCommand extends Command<int> {
  /// {@macro start_command}
  StartCommand({
    required Logger logger,
  }) : _logger = logger;

  @override
  String get description => 'Start an interactive UI.';

  @override
  String get name => 'start';

  final Logger _logger;

  @override
  Future<int> run() async {
    try {
      final melosFileExists = File('melos.yaml').existsSync();
      final availableCommands = [
        if (!melosFileExists) ArchipelagoCommand.initializeMonorepo,
        ArchipelagoCommand.generateFeatureSkeleton,
        ArchipelagoCommand.generateCubitSkeleton,
        ArchipelagoCommand.generateLocalization,
        ArchipelagoCommand.generateUIKit,
      ];

      final action = _logger.chooseOne<ArchipelagoCommand>(
        'What would you like to do today? Choose an option to get started:',
        choices: availableCommands,
        display: (choice) => choice.label,
      );

      final result = switch (action) {
        ArchipelagoCommand.initializeMonorepo =>
          await InitializeMonorepoCommand(logger: _logger).run(),
        ArchipelagoCommand.generateFeatureSkeleton =>
          await GenerateFeatureSkeletonCommand(logger: _logger).run(),
        ArchipelagoCommand.generateCubitSkeleton => throw UnimplementedError(),
        ArchipelagoCommand.generateLocalization =>
          await GenerateLocalizationPackageCommand(logger: _logger).run(),
        ArchipelagoCommand.generateUIKit =>
          await GenerateUIKitCommand(logger: _logger).run(),
      };

      return result;
    } catch (e) {
      _logger
        ..err(e.toString())
        ..info('');
      return ExitCode.usage.code;
    }
  }
}
