import 'package:core/src/di/di.dart';
import 'package:core/src/network/http/http.dart';
{{#isUsingDio}}
import 'package:core/src/network/http/http_client.dart';
{{/isUsingDio}}
{{#isUsingHttp}}
import 'package:http/http.dart';
{{/isUsingHttp}}
import 'package:dependencies/injectable/injectable.dart';

@LazySingleton()
class {{appName.pascalCase()}}HttpModule extends HttpModule {
  {{#isUsingDio}}
  {{appName.pascalCase()}}HttpModule() : super(getIt<HttpClient>());
  {{/isUsingDio}}
  {{#isUsingHttp}}
  {{appName.pascalCase()}}HttpModule() : super(getIt<Client>(), setting: getIt<HttpSetting>(),);
  {{/isUsingHttp}}
}
