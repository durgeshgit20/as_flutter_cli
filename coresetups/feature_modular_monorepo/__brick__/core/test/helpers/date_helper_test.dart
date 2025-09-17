import 'package:core/src/helpers/helpers.dart';
import 'package:dependencies/intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateHelper Tests', () {
    setUp(() {
      // Set locale for consistent test results
      Intl.defaultLocale = 'en_US';
    });

    group('dateWithDayFormat', () {
      test('should return correctly formatted date with default format', () {
        final date = DateTime(2024, 5, 2); // Example date: May 2, 2024
        expect(
          DateHelper.dateWithDayFormat(date),
          equals('Thursday, 02 May 2024'),
        );
      });

      test('should return date with customized format', () {
        final date = DateTime(2024, 5, 2); // Example date: May 2, 2024
        expect(
          DateHelper.dateWithDayFormat(date, format: 'dd-MM-yyyy'),
          equals('02-05-2024'),
        );
      });

      test('should include timezone information if requested', () {
        final date = DateTime.now(); // Using current date and time
        final expectedFormattedDate =
            DateFormat('EEEE, dd MMMM yyyy').format(date);
        final expectedOutput = '$expectedFormattedDate ${date.timeZoneName}';

        expect(
          DateHelper.dateWithDayFormat(date, includeTimeZone: true),
          equals(expectedOutput),
        );
      });
    });
  });
}
