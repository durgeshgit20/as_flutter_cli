import 'package:config/config.dart';
import 'package:core/src/log/log.dart';
{{#isUsingDio}}
import 'package:core/src/network/http/http_client.dart';
{{/isUsingDio}}
import 'package:core/src/network/http/http_setting.dart';
import 'package:dependencies/dependencies.dart';
import 'package:device_info_plus/device_info_plus.dart';
{{#isUsingHttp}}
import 'package:http/http.dart';
{{/isUsingHttp}}
import 'package:dependencies/injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class RegisterModule {
  Logger get logger => Logger(
        filter: ReleaseLogFilter(),
        printer: PrefixPrinter(
          SimpleLogPrinter(),
          error: '{{appName.pascalCase()}}Error -',
          debug: '{{appName.pascalCase()}}Log -',
          fatal: '{{appName.pascalCase()}}Fatal -',
          info: '{{appName.pascalCase()}}Info -',
          trace: '{{appName.pascalCase()}}Trace -',
          warning: '{{appName.pascalCase()}}Warning -',
        ),
      );

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  {{#isUsingDio}}
  HttpClient get httpClient => HttpClient.init(
        HttpSetting(
          baseUrl: Env.apiBaseUrl,
        ),
      );
  {{/isUsingDio}}
  {{#isUsingHttp}}
  Client get httpClient => Client();
  HttpSetting get httpSetting => HttpSetting(
        baseUrl: Env.apiBaseUrl,
        contentType: 'application/json',
      );
  {{/isUsingHttp}}
}
