import 'package:dependencies/intl/intl.dart';
import 'package:l10n/l10n.dart';

class DateHelper {
  DateHelper._();

  static String dateWithDayFormat(
    DateTime date, {
    String format = 'EEEE, dd MMMM yyyy',
    bool includeTimeZone = false,
    String? locale,
  }) {
    final formattedDate = DateFormat(
      format,
      locale ?? AppLocaleUtils.findDeviceLocale().languageCode,
    ).format(date);

    if (includeTimeZone) {
      final timezone = date.timeZoneName;
      final buffer = StringBuffer()..writeAll([formattedDate, timezone], ' ');
      return buffer.toString();
    }

    return formattedDate;
  }
}
