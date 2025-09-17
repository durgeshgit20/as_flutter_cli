import 'package:dependencies/auto_route/auto_route.dart';
import 'package:home/src/router/router.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen|Page,Route',
)
class HomeRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
      AutoRoute(
        page: HomeRoute.page,
        path: '/home',
      ),
    ];
}
