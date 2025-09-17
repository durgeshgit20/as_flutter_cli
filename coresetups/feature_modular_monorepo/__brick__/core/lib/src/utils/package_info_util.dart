import 'package:dependencies/injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

@Injectable()
class PackageInfoUtil {
  final PackageInfo _packageInfo;

  const PackageInfoUtil(this._packageInfo);

  String version() => _packageInfo.version;
  String buildNumber() => _packageInfo.buildNumber;
  String appName() => _packageInfo.appName;

  bool isUpdateAvailable(String latestVersion) {
    final currentVersion = Version.parse(version());
    final latest = Version.parse(latestVersion);
    return latest > currentVersion;
  }
}
