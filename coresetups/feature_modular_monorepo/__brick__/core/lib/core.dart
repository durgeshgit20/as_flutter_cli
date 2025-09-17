/// {@template core}
/// Core package of {{appName.titleCase()}}.
/// {@endtemplate}
library core;

{{#isUsingFirebase}}export 'package:firebase_core/firebase_core.dart';{{/isUsingFirebase}}

export 'src/data/data.dart';
export 'src/di/injector.module.dart';
export 'src/exceptions/exceptions.dart';
export 'src/extensions/extensions.dart';
export 'src/failures/failures.dart';
export 'src/helpers/helpers.dart';
export 'src/log/log.dart';
export 'src/network/network.dart';
export 'src/typedef/typedef.dart';
export 'src/usecases/usecase.dart';
export 'src/utils/utils.dart';
