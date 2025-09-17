import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/injectable/injectable.dart';

final getIt = GetIt.instance;

@microPackageInit
void injector{{featureName.pascalCase()}}Module() {}
