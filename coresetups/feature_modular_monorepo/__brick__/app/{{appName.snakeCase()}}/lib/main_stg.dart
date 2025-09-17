import 'package:config/config.dart';
import 'package:l10n/l10n.dart';
import 'package:{{appName.snakeCase()}}/app.dart';
import 'package:{{appName.snakeCase()}}/bootstrap.dart';

void main() => bootstrap(
      () async {
        Flavor.status = FlavorStatus.staging;

        return TranslationProvider(
          child: const App(),
        );
      },
    );
