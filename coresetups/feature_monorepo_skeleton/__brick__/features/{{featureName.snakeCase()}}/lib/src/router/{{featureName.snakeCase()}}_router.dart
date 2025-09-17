import 'package:dependencies/dependencies.dart';
import 'package:{{featureName.snakeCase()}}/src/router/router.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen|Page,Route',
)
class {{featureName.pascalCase()}}Router extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
      AutoRoute(
        page: {{featureName.pascalCase()}}Route.page,
        path: '/{{featureName.snakeCase()}}',
      ),
    ];
}
