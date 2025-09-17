import 'package:envied/envied.dart';

part 'env_stg.g.dart';  

@Envied(
  path: '.env.stg',
  obfuscate: true,
  useConstantCase: true,
  name: 'EnvStg',
)
abstract class EnvStg {
  @EnviedField()
  static final String apiBaseUrl = _EnvStg.apiBaseUrl;
  @EnviedField()
  static final String aesKey = _EnvStg.aesKey;
}
