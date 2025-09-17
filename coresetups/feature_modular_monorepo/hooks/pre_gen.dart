import 'package:path/path.dart';
import 'package:mason/mason.dart';
import 'enums/prefix_casing_strategy.dart';

Future<void> run(HookContext context) async {
  final namingStrategy = PrefixCasingStrategy.fromValue(
    (context.vars['prefixCasing'] as String).camelCase,
  );
  final isUsingFirebase = context.vars['isUsingFirebase'] as bool;

  final rawPrefix = context.vars['prefix'] as String;
  final appName = context.vars['appName'] as String;

  final prefix = rawPrefix.isEmpty
      ? appName.pascalCase
      : _formatPrefix(
          namingStrategy,
          prefix: rawPrefix,
        );

  final appNamePrefix = appName.snakeCase;

  final logger = context.logger;

  List<String> projectIDS = [];

  if (isUsingFirebase && !context.vars.containsKey('firebaseProject')) {
    final flavors = ['Development', 'Staging', 'Production'];
    for (final flavor in flavors) {
      final projectID = logger.prompt(
        'Enter Firebase APP ID for ${flavor} flavor: ',
      );
      projectIDS.add(projectID);
    }
  }

  // Prompt for paid bundles
  final hasPaidBundles = logger.confirm(
    'Do you have any paid bundles?',
    defaultValue: false,
  );

  List<String> selectedBundles = [];
  if (hasPaidBundles) {
    final availableBundles = [
      'security_package_bundle',
      'debugger_bundle',
      // Add more paid bundles as needed
    ];

    selectedBundles = logger.chooseAny<String>(
      'Select the paid bundles you want to include:',
      choices: availableBundles,
      defaultValues: const [],
    );
  }

  final networkLibrary = context.vars['networkLibrary'] as String;

  context.vars = {
    ...context.vars,
    'prefix': prefix,
    'uiKitPath': join('packages', '${appNamePrefix}_ui_kit'),
    'widgetbookPath': join('app', '${appNamePrefix}_widgetbook'),
    'l10nPath': join('shared', 'l10n'),
    'paidBundles': selectedBundles,
    'isUsingDio': networkLibrary == 'dio',
    'isUsingHttp': networkLibrary == 'http',
    'githubWorkspace': '\${{ github.workspace }}',
    'githubToken': '\${{ secrets.GITHUB_TOKEN }}',
    'githubWorkflow': '\${{ github.workflow }}',
    'githubRef': '\${{ github.head_ref }}',
    if (isUsingFirebase && projectIDS.length == 3) ...{
      'firebaseProject': projectIDS.first,
      'firebaseProjectDev': projectIDS[1],
      'firebaseProjectStg': projectIDS.last,
    }
  };
}

String _formatPrefix(
  PrefixCasingStrategy state, {
  required String prefix,
}) {
  if (state == PrefixCasingStrategy.upperCase) {
    return prefix.upperCase;
  }

  return prefix.pascalCase;
}
