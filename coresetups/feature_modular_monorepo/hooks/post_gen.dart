import 'helpers/post_gen_helper.dart';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final vars = context.vars;
  int failCount = 0;

  failCount += await generateUIKit(logger, vars);
  failCount += await generateI10n(logger, vars);

  // Dynamically check and generate paid bundles
  failCount += await generatePaidBundles(logger, vars);

  failCount += await prepareEnv(logger, vars);
  failCount += await generateMainApp(logger, vars);
  failCount += await setupRootDependencies(logger);
  failCount += await setupMelos(logger);
  failCount += await updateScriptsPermissions(logger);
  failCount += await runMelosCommands(logger);

  if (failCount == 0) {
    logger.success(
      'Successfully generated the skeleton of your monorepo Flutter app!',
    );
    logger.info(
      'Next steps:',
    );
    logger.info(
      '1. Review the generated code and configurations',
    );
    logger.info(
      '2. Navigate to your app directory',
    );
    logger.info(
      '3. Run "melos get" to ensure all dependencies are up to date',
    );
    logger.info(
      '4. Start building your awesome app!',
    );
    logger.info(
      blue.wrap(
        '\nIf you found this template helpful, please consider:\n'
        '- Following me on GitHub: \n'
        '  - Banua Coder: https://github.com/banuacoders \n'
        '  - Me: https://github.com/ryanaidilp \n'
        '- Sharing about this project with your network\n'
        '- Subscribing to my YouTube channel: \n'
        '   - Banua Coder: https://www.youtube.com/@banuacoder\n'
        'Your support helps me create more content and tools like this!\n\n'
        'I am also open to new opportunities. Feel free to contact me at:\n'
        '- Email: fajrianaidilp@gmail.com\n'
        '- LinkedIn: https://www.linkedin.com/in/ryanaidilp/',
      ),
    );
  } else {
    logger.warn(
      'Generation completed with ${failCount} error(s). Please review the logs and address any issues before proceeding.',
    );
    logger.info(
      'For assistance, check the documentation or open an issue on the project repository.',
    );
  }
}
