import 'package:mason/mason.dart';
import 'helpers/post_gen_helpers.dart';

Future<void> run(HookContext context) async {
  final appName = context.vars['appName'] as String;
  final featureName = context.vars['featureName'] as String;

  int failCount = 0;

  if (!await runFlutterPubGet(context, featureName)) failCount++;
  if (!await runBuildRunner(context, featureName)) failCount++;
  if (!updatePubspec(context, appName, featureName)) failCount++;
  if (!updateRouter(context, appName, featureName)) failCount++;
  if (!await runMelosGet(context)) failCount++;
  if (!await runMelosFormatAndFix(context)) failCount++;

  if (failCount > 0) {
    context.logger.warn(
      'Post-generation tasks completed with $failCount errors. '
      'Please check the logs above for details.',
    );
  } else {
    context.logger.success('All post-generation tasks completed successfully!');
  }
}
