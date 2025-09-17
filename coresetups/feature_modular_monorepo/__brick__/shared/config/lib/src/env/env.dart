import 'package:config/config.dart';
import 'package:config/src/env/env_dev.dart';
import 'package:config/src/env/env_stg.dart';
import 'package:config/src/env/env_prod.dart';

/// This class is used to map the generated env from
/// envied generator based on the app flavor.
class Env {
  const Env._();

  static String apiBaseUrl = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.apiBaseUrl,
    FlavorStatus.staging => EnvStg.apiBaseUrl,
    FlavorStatus.production => EnvProd.apiBaseUrl,
    _ => EnvDev.apiBaseUrl,
  };

  static String aesKey = switch (Flavor.status) {
    FlavorStatus.development => EnvDev.aesKey,
    FlavorStatus.staging => EnvStg.aesKey,
    FlavorStatus.production => EnvProd.aesKey,
    _ => EnvDev.aesKey,
  };
}
