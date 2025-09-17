import 'package:mason/mason.dart';
import 'dart:io';

void run(HookContext context) async {
  // Get the current working directory
  final cwd = Directory.current;

  // Find the app directory
  final appDir = Directory('${cwd.path}/app');

  if (!await appDir.exists()) {
    context.logger.err('App directory not found!');
    exit(1);
  }

  // List all directories inside the app directory
  final apps = await appDir
      .list()
      .where((entity) => entity is Directory)
      .map((dir) => dir.path.split(Platform.pathSeparator).last)
      .toList();

  if (apps.isEmpty) {
    context.logger.err('No apps found in the app directory!');
    exit(1);
  }

  // Prompt user to select an app
  final selectedApp = context.logger.chooseOne(
    'Select the app for this feature:',
    choices: apps,
  );

  // Add the selected app to the variables
  context.vars['appName'] = selectedApp;
}
