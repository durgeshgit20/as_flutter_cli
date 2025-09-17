import 'dart:io';
import 'package:mason/mason.dart';
import 'package:yaml_edit/yaml_edit.dart';
import 'package:path/path.dart';

Future<bool> runFlutterPubGet(HookContext context, String featureName) async {
  final progress = context.logger.progress('Running flutter pub get');
  final featureDir = join('features', featureName.snakeCase);

  // Run flutter pub get
  final pubGetResult = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: featureDir,
  );

  if (pubGetResult.exitCode == 0) {
    progress.complete('Successfully ran flutter pub get in $featureDir');
    return true;
  } else {
    progress.fail('Failed to run flutter pub get in $featureDir');
    context.logger.err(pubGetResult.stderr);
    return false;
  }
}

Future<bool> runBuildRunner(HookContext context, String featureName) async {
  final progress = context.logger.progress('Running build_runner');
  // Run build_runner in the feature directory
  final featureDir = join('features', featureName.snakeCase);
  await Process.run('dart', ['pub', 'get'], workingDirectory: featureDir);
  final result = await Process.run(
    'dart',
    ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    workingDirectory: featureDir,
  );

  if (result.exitCode == 0) {
    progress.complete('Successfully ran build_runner in $featureDir');
    return true;
  } else {
    progress.fail('Failed to run build_runner in $featureDir');
    context.logger.err(result.stderr);
    return false;
  }
}

bool updatePubspec(HookContext context, String appName, String featureName) {
  final progress = context.logger.progress('Updating pubspec.yaml');
  final pubspecPath = join('app', appName.snakeCase, 'pubspec.yaml');
  final pubspecFile = File(pubspecPath);
  final pubspecContent = pubspecFile.readAsStringSync();

  final yamlEditor = YamlEditor(pubspecContent);
  final packageName = featureName.snakeCase;
  final packagePath = join('..', '..', 'features', packageName);

  try {
    yamlEditor.update(['dependencies', packageName], {'path': packagePath});
  } catch (e) {
    yamlEditor.update([
      'dependencies'
    ], {
      packageName: {'path': packagePath}
    });
  }

  pubspecFile.writeAsStringSync(yamlEditor.toString());
  progress.complete('Added $packageName to $pubspecPath');
  return true;
}

bool updateRouter(HookContext context, String appName, String featureName) {
  final progress = context.logger.progress('Updating router');
  final routerPath = join('app', appName.snakeCase, 'lib', 'router',
      '${appName.snakeCase}_router.dart');
  final routerFile = File(routerPath);
  final routerContent = routerFile.readAsStringSync();

  final importStatement =
      "import 'package:${featureName.snakeCase}/${featureName.snakeCase}.dart';";
  final routerDeclaration =
      "final _${featureName.camelCase}Router = ${featureName.pascalCase}Router();";
  final routeAddition = "..._${featureName.camelCase}Router.routes,";

  final lines = routerContent.split('\n');
  var updatedLines = <String>[];
  var importAdded = false;
  var routerDeclAdded = false;
  var routeAdded = false;

  for (var line in lines) {
    updatedLines.add(line);

    if (!importAdded &&
        line.startsWith('import') &&
        !line.contains(importStatement)) {
      updatedLines.add(importStatement);
      importAdded = true;
    } else if (!routerDeclAdded && line.contains('EntryPointNewRoutes')) {
      updatedLines.add('  $routerDeclaration');
      routerDeclAdded = true;
    } else if (!routeAdded && line.contains('AppendNewRoutes')) {
      updatedLines.add('    $routeAddition');
      routeAdded = true;
    }
  }

  final updatedContent = updatedLines.join('\n');
  routerFile.writeAsStringSync(updatedContent);
  progress.complete('Updated router file: $routerPath');
  return true;
}

Future<bool> runMelosGet(HookContext context) async {
  final progress = context.logger.progress('Running melos get');

  // Run melos get in the root directory
  final result = await Process.run(
    'melos',
    ['get'],
    workingDirectory: '.',
  );

  if (result.exitCode == 0) {
    progress.complete('Successfully ran melos get');
    return true;
  } else {
    progress.fail('Failed to run melos get');
    context.logger.err(result.stderr);
    return false;
  }
}

Future<bool> runMelosFormatAndFix(HookContext context) async {
  final progress = context.logger.progress('Running melos format and fix');

  // Run melos get in the root directory
  final resultFormat = await Process.run(
    'melos',
    ['format'],
    workingDirectory: '.',
  );

  if (resultFormat.exitCode == 0) {
    progress.complete('Successfully ran melos format');
  } else {
    progress.fail('Failed to run melos format');
    context.logger.err(resultFormat.stderr);
  }

  final resultFix = await Process.run(
    'melos',
    ['fix'],
    workingDirectory: '.',
  );

  if (resultFix.exitCode == 0) {
    progress.complete('Successfully ran melos fix');
    return true;
  } else {
    progress.fail('Failed to run melos fix');
    context.logger.err(resultFix.stderr);
    return false;
  }
}
