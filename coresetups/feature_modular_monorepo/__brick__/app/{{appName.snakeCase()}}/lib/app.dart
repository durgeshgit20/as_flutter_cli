import 'package:dependencies/auto_route/auto_route.dart';
import 'package:{{appName.snakeCase()}}/di/di.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';
import 'package:{{appName.snakeCase()}}/router/router.dart';
import 'package:{{appName.snakeCase()}}_ui_kit/{{appName.snakeCase()}}_ui_kit.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final _router = {{appName.pascalCase()}}Router();

  @override
  Widget build(BuildContext context) => {{prefix}}ComponentInit(
        builder: (_) => MaterialApp.router(
          title: '{{appName.titleCase()}}',
          debugShowCheckedModeBanner: false,
          routerDelegate: AutoRouterDelegate(
            _router,
            navigatorObservers: () => [
              HeroineController(),
              {{appName.pascalCase()}}RouteObserver(),
            ],
          ),
          builder: (_, child) => LoaderOverlay(
            overlayColor: context.{{prefix.camelCase()}}Color.overlay,
            overlayWidgetBuilder: (progress) => Center(
              child: SpinKitCircle(
                color: context.{{prefix.camelCase()}}Color.action.primary.active,
                size: {{prefix}}Size.size32.sp,
              ),
            ),
            child: child ?? nil,
          ),
          routeInformationParser: _router.defaultRouteParser(),
          theme: {{prefix}}Theme.light(ThemeData.light()).themeData,
          darkTheme: {{prefix}}Theme.dark(ThemeData.dark()).themeData,
          locale: LocaleSettings.currentLocale.flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          scaffoldMessengerKey:
                  getIt<MessengerUtil>().rootScaffoldMessengerKey,
        ),
      );
}
