import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart';
import '../bundle/flutter_l10n_package_bundle.dart';
import '../bundle/flutter_ui_kit_bundle.dart';

Future<int> prepareEnv(Logger logger, Map<String, dynamic> vars) async {
  int failCount = 0;
  final currentDirectory = Directory.current.path;
  final desiredDirectory = join(currentDirectory, 'shared', 'config');

  logger.info(blue.wrap('Preparing .env files...'));

  final envFiles = ['.env', '.env.stg', '.env.dev'];

  await Future.wait(envFiles.map((envFile) async {
    final createEnvProgress = logger.progress('Creating $envFile');
    try {
      await Process.run('cp', ['.env.example', envFile],
          workingDirectory: desiredDirectory);
      createEnvProgress.complete('$envFile created successfully');
    } catch (e) {
      createEnvProgress.fail('Failed to create $envFile: $e');
      failCount++;
    }
  }));
  return failCount;
}

Future<int> generateMainApp(
  Logger logger,
  Map<String, dynamic> vars,
) async {
  int failCount = 0;
  final appName = vars['appName'] as String;
  final domain = vars['domain'] as String;
  final organization = vars['organization'] as String;

  final newPath = join(Directory.current.path, 'app', appName.snakeCase);
  final corePath = Directory.current.path;

  logger.info(blue.wrap('Creating main app project...'));

  failCount += await createFlutterProject(
    logger,
    domain,
    organization,
    appName,
    newPath,
  );
  failCount += await removeUnusedFiles(logger, newPath);
  failCount += await installPackages(logger, newPath);
  failCount += await installPackages(logger, newPath);
  failCount += await _changeBundleId(logger, vars, newPath);
  // failCount += await runFlutterFlavorizr(logger, newPath);
  failCount += await addFlutterTestToCore(logger, corePath);
  failCount += await updateIdeaConfiguration(logger, newPath);
  failCount += await generateLauncherIcons(logger, newPath);
  failCount += await generateSplashScreen(logger, newPath);

  if (failCount == 0) {
    logger.success('Main app created successfully!');
  } else {
    logger.warn('Main app creation encountered some issues.');
  }
  return failCount;
}

Future<int> _changeBundleId(
  Logger logger,
  Map<String, dynamic> vars,
  String path,
) async {
  final progress =
      logger.progress('Changing app package name and bundle ID...');
  int failCount = 0;
  try {
    final domain = vars['domain'] as String;
    final organization = vars['organization'] as String;
    final appName = vars['appName'] as String;
    final result = await Process.run(
      'dart',
      [
        'run',
        'change_app_package_name:main',
        '${domain.lowerCase}.${organization.snakeCase}.${appName.snakeCase}',
      ],
      workingDirectory: path,
    );
    if (result.exitCode != 0) throw result.stderr;
    progress.complete('Bundle ID and package name updated');
  } catch (e) {
    progress.fail('Failed to update bundle ID and package name: $e');
    failCount++;
  }

  return failCount;
}

Future<int> setupRootDependencies(Logger logger) async {
  int failCount = 0;
  final progress = logger.progress('Installing root dependencies...');
  try {
    final result = await Process.run('flutter', ['pub', 'get'],
        workingDirectory: Directory.current.path);
    if (result.exitCode != 0) throw result.stderr;
    progress.complete('Root dependencies installed successfully');
  } catch (e) {
    progress.fail('Failed to install root dependencies: $e');
    failCount++;
  }
  return failCount;
}

Future<int> setupMelos(Logger logger) async {
  int failCount = 0;
  final checkProgress = logger.progress('Checking for melos...');
  try {
    final result = await Process.run('dart', ['pub', 'global', 'list']);
    if (!result.stdout.toString().contains('melos')) {
      checkProgress.complete('Melos not found. Activating...');
      final activateProgress = logger.progress('Activating melos...');
      final activateResult = await Process.run(
        'dart',
        ['pub', 'global', 'activate', 'melos'],
      );
      if (activateResult.exitCode != 0) throw activateResult.stderr;
      activateProgress.complete('Melos activated');
    } else {
      checkProgress.complete('Melos is already active');
    }
  } catch (e) {
    checkProgress.fail('Failed to check/activate melos: $e');
    failCount++;
  }
  return failCount;
}

Future<int> updateScriptsPermissions(Logger logger) async {
  int failCount = 0;
  final progress = logger.progress('Updating scripts permissions...');
  try {
    final scriptsDir = Directory('${Directory.current.path}/scripts');
    if (await scriptsDir.exists()) {
      if (Platform.isWindows) {
        // For Windows, we don't need to change permissions
        progress.complete(
            'Scripts permissions updated (not applicable on Windows)');
      } else {
        final result =
            await Process.run('chmod', ['-R', '+x', scriptsDir.path]);
        if (result.exitCode != 0) throw result.stderr;
        progress.complete('Scripts permissions updated successfully');
      }
    } else {
      progress
          .complete('Scripts directory not found, skipping permission update');
    }
  } catch (e) {
    progress.fail('Failed to update scripts permissions: $e');
    failCount++;
  }
  return failCount;
}

Future<int> runMelosCommands(Logger logger) async {
  int failCount = 0;
  final bootstrapProgress = logger.progress('Running melos bootstrap...');
  try {
    final bootstrapResult = await Process.run('melos', ['bs'],
        workingDirectory: Directory.current.path);
    if (bootstrapResult.exitCode != 0) throw bootstrapResult.stderr;
    bootstrapProgress.complete('Melos bootstrap completed');

    final formatProgress = logger.progress('Running melos format...');
    final formatResult = await Process.run('melos', ['format'],
        workingDirectory: Directory.current.path);
    if (formatResult.exitCode != 0) throw formatResult.stderr;
    formatProgress.complete('Melos format completed');

    final fixProgress = logger.progress('Running melos fix...');
    final fixResult = await Process.run('melos', ['fix'],
        workingDirectory: Directory.current.path);
    if (fixResult.exitCode != 0) throw fixResult.stderr;
    fixProgress.complete('Melos fix completed');
  } catch (e) {
    bootstrapProgress.fail('Failed to run melos commands: $e');
    failCount++;
  }
  return failCount;
}

Future<int> createFlutterProject(Logger logger, String domain,
    String organization, String appName, String workingDirectory) async {
  int failCount = 0;
  final progress = logger.progress('Creating Flutter project...');
  try {
    final result = await Process.run(
      'flutter',
      [
        'create',
        '.',
        '--platforms=ios,android',
        '--org=${domain.lowerCase}.${organization.dotCase}.${appName.dotCase}'
      ],
      workingDirectory: workingDirectory,
    );
    if (result.exitCode != 0) throw result.stderr;
    progress.complete('Flutter project created successfully');
  } catch (e) {
    progress.fail('Failed to create Flutter project: $e');
    failCount++;
  }
  return failCount;
}

Future<int> removeUnusedFiles(Logger logger, String workingDirectory) async {
  int failCount = 0;
  final progress = logger.progress('Removing unused files...');
  try {
    await Process.run('rm', ['-rf', 'test'],
        workingDirectory: workingDirectory);
    progress.complete('Unused files removed');
  } catch (e) {
    progress.fail('Failed to remove unused files: $e');
    failCount++;
  }
  return failCount;
}

Future<int> installPackages(Logger logger, String workingDirectory) async {
  int failCount = 0;
  final progress = logger.progress('Installing packages...');
  try {
    final result = await Process.run('flutter', ['pub', 'get'],
        workingDirectory: workingDirectory);
    if (result.exitCode != 0) throw result.stderr;
    progress.complete('Packages installed successfully');
  } catch (e) {
    progress.fail('Failed to install packages: $e');
    failCount++;
  }
  return failCount;
}

Future<int> runFlutterFlavorizr(Logger logger, String workingDirectory) async {
  int failCount = 0;
  final progress = logger.progress('Running flutter_flavorizr...');
  try {
    final result = await Process.run(
      'dart',
      [
        'run',
        'flutter_flavorizr',
      ],
      workingDirectory: workingDirectory,
    );
    if (result.exitCode != 0) throw result.stderr;
    progress.complete('flutter_flavorizr completed successfully');
  } catch (e) {
    progress.fail('Failed to run flutter_flavorizr: $e');
    failCount++;
  }
  return failCount;
}

Future<int> updateIdeaConfiguration(
    Logger logger, String workingDirectory) async {
  int failCount = 0;
  final ideaRunConfigProgress =
      logger.progress('Updating idea configuration...');
  try {
    // // Delete original lib folder
    // await Directory(join(workingDirectory, 'lib')).delete(recursive: true);

    // // Rename mainapp_lib to lib
    // await Directory(join(workingDirectory, 'mainapp_lib'))
    //     .rename(join(workingDirectory, 'lib'));

    // Replace runConfiguration in .idea

    final ideaDir = Directory(join(workingDirectory, '.idea'));
    if (await ideaDir.exists()) {
      await ideaDir.delete(recursive: true);
    }
    ideaRunConfigProgress
        .complete('idea runConfigurations updated successfully!');

    // // Update iOS/Flutter content
    // final iosFlutterDir = Directory(join(workingDirectory, 'ios', 'Flutter'));
    // final mainIosFlutterDir =
    //     Directory(join(workingDirectory, 'main_ios', 'Flutter'));
    // if (await iosFlutterDir.exists() && await mainIosFlutterDir.exists()) {
    //   // Copy contents from main_ios/Flutter to ios/Flutter
    //   await for (final entity in mainIosFlutterDir.list()) {
    //     final targetPath = join(iosFlutterDir.path, basename(entity.path));
    //     if (entity is File) {
    //       await entity.copy(targetPath);
    //     } else if (entity is Directory) {
    //       await Directory(targetPath).create(recursive: true);
    //       await copyDirectory(entity, Directory(targetPath));
    //     }
    //   }

    //   // Delete main_ios directory
    //   await Directory(join(workingDirectory, 'main_ios'))
    //       .delete(recursive: true);
    // } else {
    //   logger.warn(
    //     'ios/Flutter or main_ios/Flutter directory not found. Skipping iOS Flutter content update.',
    //   );
    // }

    // progress.complete(
    //   'Lib folder replaced and configurations updated successfully',
    // );
  } catch (e) {
    ideaRunConfigProgress.fail('Failed to update idea configuration: $e');
    failCount++;
  }
  return failCount;
}

Future<int> generateLauncherIcons(
    Logger logger, String workingDirectory) async {
  int failCount = 0;
  final progress = logger.progress('Generating launcher icons...');
  try {
    final result = await Process.run(
      'dart',
      ['run', 'flutter_launcher_icons:main'],
      workingDirectory: workingDirectory,
    );
    if (result.exitCode != 0) throw result.stderr;
    progress.complete('Launcher icons generated');
  } catch (e) {
    progress.fail('Failed to generate launcher icons: $e');
    failCount++;
  }
  return failCount;
}

Future<int> generateSplashScreen(Logger logger, String workingDirectory) async {
  int failCount = 0;
  final progress = logger.progress('Generating splash screen...');
  try {
    final result = await Process.run(
      'dart',
      ['run', 'flutter_native_splash:create'],
      workingDirectory: workingDirectory,
    );
    if (result.exitCode != 0) throw result.stderr;
    progress.complete('Splash screen generated');
  } catch (e) {
    progress.fail('Failed to generate splash screen: $e');
    failCount++;
  }
  return failCount;
}

Future<int> generateUIKit(
  Logger logger,
  Map<String, dynamic> vars,
) async {
  int failCount = 0;
  logger.info(blue.wrap('Generating UI Kit Package...'));

  try {
    final workingDirectory = DirectoryGeneratorTarget(Directory.current);
    // final bundlePath = join(
    //   Platform.script.toFilePath().split('build').first,
    //   'bundle',
    //   'flutter_ui_kit.bundle',
    // );
    // final bundleBytes = File(bundlePath).readAsBytesSync();
    // final flutterUiKitBundle =
    //     await MasonBundle.fromUniversalBundle(bundleBytes);
    final uiKitGenerator = await MasonGenerator.fromBundle(flutterUiKitBundle);
    await uiKitGenerator.generate(
      workingDirectory,
      fileConflictResolution: FileConflictResolution.overwrite,
      vars: {...vars, 'isForMonorepo': true},
    );
    await uiKitGenerator.hooks.postGen(
      workingDirectory: workingDirectory.dir.path,
      vars: vars,
    );
  } catch (e) {
    logger.err('Failed to generate UI Kit Package: $e');
    failCount++;
  }
  return failCount;
}

Future<int> generateI10n(
  Logger logger,
  Map<String, dynamic> vars,
) async {
  int failCount = 0;
  logger.info(blue.wrap('Generating l10n Package...'));

  try {
    final workingDirectory = DirectoryGeneratorTarget(Directory.current);
    // final bundlePath = join(
    //   Platform.script.toFilePath().split('build').first,
    //   'bundle',
    //   'flutter_l10n_package.bundle',
    // );
    // final bundleBytes = File(bundlePath).readAsBytesSync();
    // final flutterL10nPackageBundle =
    //     await MasonBundle.fromUniversalBundle(bundleBytes);
    final l10nGenerator =
        await MasonGenerator.fromBundle(flutterL10nPackageBundle);
    await l10nGenerator.generate(
      workingDirectory,
      fileConflictResolution: FileConflictResolution.overwrite,
      vars: {...vars, 'isForMonorepo': true},
    );
    await l10nGenerator.hooks.postGen(
      workingDirectory: workingDirectory.dir.path,
      vars: vars,
    );
  } catch (e) {
    logger.err('Failed to generate l10n Package: $e');
    failCount++;
  }
  return failCount;
}

Future<int> generatePaidBundles(
    Logger logger, Map<String, dynamic> vars) async {
  int failCount = 0;
  final paidBundles = vars['paidBundles'];

  for (final bundle in paidBundles) {
    try {
      // Dynamically import the bundle
      final bundlePath = join(
        Platform.script.toFilePath().split('build').first,
        'bundle',
        '${bundle}.bundle',
      );
      final bundleFile = File(bundlePath);
      if (await bundleFile.exists()) {
        // If the bundle file exists, import it and generate
        final bundleImport = await bundleFile.readAsString();
        final bundleName = bundleImport.split(' ').last.replaceAll(';', '');
        final bundleDart = await MasonBundle.fromUniversalBundle(
          await bundleFile.readAsBytes(),
        );

        logger.info(blue.wrap('Generating $bundleName...'));

        // Use MasonGenerator to generate from the bundle
        final generator = await MasonGenerator.fromBundle(bundleDart);
        final workingDirectory = DirectoryGeneratorTarget(Directory.current);
        await generator.generate(
          workingDirectory,
          fileConflictResolution: FileConflictResolution.overwrite,
          vars: {...vars, 'isForMonorepo': true},
        );
        await generator.hooks.postGen(
          workingDirectory: workingDirectory.dir.path,
          vars: vars,
        );

        logger.success('$bundleName generated successfully');
      } else {
        logger.warn('Bundle file for $bundle not found. Skipping generation.');
      }
    } catch (e) {
      logger.err('Failed to generate $bundle: $e');
      failCount++;
    }
  }

  return failCount;
}

// Helper function to copy directory contents recursively
Future<void> copyDirectory(Directory source, Directory destination) async {
  await for (final entity in source.list(recursive: false)) {
    if (entity is Directory) {
      final newDirectory =
          Directory(join(destination.path, basename(entity.path)));
      await newDirectory.create();
      await copyDirectory(entity, newDirectory);
    } else if (entity is File) {
      await entity.copy(join(destination.path, basename(entity.path)));
    }
  }
}

Future<int> addFlutterTestToCore(
  Logger logger,
  String workingDirectory,
) async {
  int failCount = 0;
  final progress =
      logger.progress('Adding flutter_test to core pubspec.yaml...');
  try {
    final corePublishYamlPath = join(workingDirectory, 'core', 'pubspec.yaml');
    final file = File(corePublishYamlPath);

    if (await file.exists()) {
      String content = await file.readAsString();

      // Check if flutter_test is already present
      if (!content.contains('flutter_test:')) {
        // Find the dev_dependencies section
        final devDependenciesIndex = content.indexOf('dev_dependencies:');
        if (devDependenciesIndex != -1) {
          // Insert flutter_test under dev_dependencies
          final insertPosition =
              content.indexOf('\n', devDependenciesIndex) + 1;
          content = content.replaceRange(insertPosition, insertPosition,
              '  flutter_test:\n    sdk: flutter\n');

          await file.writeAsString(content);
          progress.complete('Added flutter_test to core pubspec.yaml');
        } else {
          progress
              .fail('dev_dependencies section not found in core pubspec.yaml');
          failCount++;
        }
      } else {
        progress.complete('flutter_test already present in core pubspec.yaml');
      }
    } else {
      progress.fail('core pubspec.yaml file not found');
      failCount++;
    }
  } catch (e) {
    progress.fail('Failed to add flutter_test to core pubspec.yaml: $e');
    failCount++;
  }
  return failCount;
}
