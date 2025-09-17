import 'package:config/config.dart';
import 'package:core/core.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/injectable/injectable.dart';
import 'package:home/home.dart';
import 'package:{{appName.snakeCase()}}/di/service_locator.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: false,
  asExtension: false,
  externalPackageModulesBefore: [
    ExternalModule(CorePackageModule),
  ],
  externalPackageModulesAfter: [
    ExternalModule(HomePackageModule),
  ],
)
Future<void> configureDependencies() async => $initGetIt(
      getIt,
      environment: Flavor.status?.name,
    );
