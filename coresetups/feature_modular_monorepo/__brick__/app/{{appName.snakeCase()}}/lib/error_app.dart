import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';
import 'package:{{appName.snakeCase()}}/di/di.dart';
import 'package:{{appName.snakeCase()}}_ui_kit/{{appName.snakeCase()}}_ui_kit.dart';

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) => {{prefix}}ComponentInit(
        builder: (_) => MaterialApp(
          title: '{{appName.titleCase()}}',
          debugShowCheckedModeBanner: false,
          theme: {{prefix}}Theme.light(ThemeData.light()).themeData,
          darkTheme: {{prefix}}Theme.dark(ThemeData.dark()).themeData,
          locale: LocaleSettings.currentLocale.flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Align(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        {{prefix}}Asset.animation(
                          animation: {{prefix}}Animations.maintenance,
                          width: 0.5.sw,
                          fit: BoxFit.cover,
                        ),
                        Gap({{prefix}}Size.size16.h),
                        Text(
                          context.l10n.error.somethingWentWrong,
                          style: {{prefix}}Typography.headingXs(),
                          textAlign: TextAlign.center,
                        ),
                        Gap({{prefix}}Size.size8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: {{prefix}}Size.size64.w,
                          ),
                          child: Text(
                            context.l10n.error.somethingWentWrong,
                            style: {{prefix}}Typography.bodySm(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        {{prefix}}Asset.logo(
                          logo: {{prefix}}Logo.banuaCoder,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getIt<PackageInfoUtil>().appName(),
                              style: {{prefix}}Typography.bodySm(),
                            ),
                            Text(
                              ' - ',
                              style: {{prefix}}Typography.bodySm(),
                            ),
                            Text(
                              'v${getIt<PackageInfoUtil>().version()}',
                              style: {{prefix}}Typography.bodySm(),
                            ),
                          ],
                        ),
                        Gap({{prefix}}Size.size32.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
