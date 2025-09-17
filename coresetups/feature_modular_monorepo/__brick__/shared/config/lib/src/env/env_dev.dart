import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(
  path: '.env.dev',
  obfuscate: true,
  useConstantCase: true,
  name: 'EnvDev',
)
abstract class EnvDev {
  @EnviedField()
  static final String apiBaseUrl = _EnvDev.apiBaseUrl;
  @EnviedField()
  static final String aesKey = _EnvDev.aesKey;
}