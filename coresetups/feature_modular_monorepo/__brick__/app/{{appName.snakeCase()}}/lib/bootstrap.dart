import 'dart:async';
import 'dart:developer';

import 'package:config/config.dart';
import 'package:core/core.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:l10n/l10n.dart';
{{#isUsingFirebase}}
import 'package:{{appName.snakeCase()}}/config/firebase_options.dart' as prod_firebase;
import 'package:{{appName.snakeCase()}}/config/firebase_options_dev.dart' as dev_firebase;
import 'package:{{appName.snakeCase()}}/config/firebase_options_stg.dart' as stg_firebase;
{{/isUsingFirebase}}
import 'package:{{appName.snakeCase()}}/di/di.dart';
import 'package:{{appName.snakeCase()}}/error_app.dart';
import 'package:{{appName.snakeCase()}}_ui_kit/{{appName.snakeCase()}}_ui_kit.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

void bootstrap(FutureOr<Widget> Function() builder) {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      addFontLicense();
      await preCacheIcons();
      await preCacheLogos();
      setPluralizationResolverForID();
      {{#isUsingFirebase}}
      await Firebase.initializeApp(
        options: switch (Flavor.status) {
          FlavorStatus.production =>
            prod_firebase.DefaultFirebaseOptions.currentPlatform,
          FlavorStatus.staging =>
            stg_firebase.DefaultFirebaseOptions.currentPlatform,
          _ => dev_firebase.DefaultFirebaseOptions.currentPlatform,
        },
      );
      {{/isUsingFirebase}}
      await configureDependencies();
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
        ],
      );
      await LocaleSettings.useDeviceLocale();
      FlutterError.onError = (details) {
        getIt<Log>().console(
          details.exceptionAsString(),
          stackTrace: details.stack,
          type: LogType.fatal,
        );
      };

      Bloc.observer = const AppBlocObserver();
      ErrorWidget.builder = (details) => const ErrorApp();
      runApp(await builder());
    },
    (error, stack) => log(error.toString()),
  );
}
