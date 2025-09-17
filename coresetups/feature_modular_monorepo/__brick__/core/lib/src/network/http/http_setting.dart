// ignore_for_file: public_member_api_docs

{{#isUsingDio}}
import 'package:dio/dio.dart';
{{/isUsingDio}}

class HttpSetting {
  const HttpSetting({
    required this.baseUrl,
    this.useHttp2 = false,
    this.contentType = 'application/json',
    this.timeout = const HttpTimeout(),
    {{#isUsingDio}}
    this.interceptors,
    {{/isUsingDio}}
  });
  final bool useHttp2;
  final String baseUrl;
  final String contentType;
  final HttpTimeout timeout;
  {{#isUsingDio}}
  final List<Interceptor>? interceptors;
  {{/isUsingDio}}
}

class HttpTimeout {
  const HttpTimeout({
    this.connectTimeout = 30000,
    this.sendTimeout = 20000,
    this.receiveTimeout = 20000,
  });
  final int connectTimeout;
  final int sendTimeout;
  final int receiveTimeout;
}
