import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(
  path: '.env',
  obfuscate: true,
  useConstantCase: true,
  name: 'EnvProd',
)
abstract class EnvProd {
  @EnviedField()
  static final String apiBaseUrl = _EnvProd.apiBaseUrl;
  @EnviedField()
  static final String aesKey = _EnvProd.aesKey;
}
