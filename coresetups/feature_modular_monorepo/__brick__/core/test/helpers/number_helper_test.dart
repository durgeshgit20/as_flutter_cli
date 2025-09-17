import 'package:core/src/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'GroupHelper',
    () {
      group('calculatePercentage', () {
        test('should return correct percentage', () {
          expect(
            NumberHelper.calculatePercentage(value: 50, total: 200),
            equals(25.0),
          );
        });

        test('should handle zero total', () {
          expect(
            NumberHelper.calculatePercentage(value: 50, total: 0).isInfinite,
            isTrue,
          );
        });

        test('should handle zero value', () {
          expect(
            NumberHelper.calculatePercentage(value: 0, total: 200),
            equals(0.0),
          );
        });
      });

      group('numberFormat', () {
        test('should format number correctly without compact', () {
          expect(NumberHelper.numberFormat(1234), equals('1,234'));
        });

        test('should format number correctly with compact', () {
          expect(
            NumberHelper.numberFormat(1234567, compact: true),
            equals('1.23M'),
          );
        });

        test('should format number with explicit sign', () {
          expect(
            NumberHelper.numberFormat(1234, showExplicitSign: true),
            equals('+1,234'),
          );
        });

        test('should format negative number with explicit sign', () {
          expect(
            NumberHelper.numberFormat(-1234, showExplicitSign: true),
            equals('-1,234'),
          );
        });
      });

      group('percentageFormat', () {
        test('should format number as percentage', () {
          expect(NumberHelper.percentageFormat(0.5), equals('50%'));
        });

        test('should format zero as percentage', () {
          expect(NumberHelper.percentageFormat(0), equals('0%'));
        });

        test('should format negative number as percentage', () {
          expect(NumberHelper.percentageFormat(-0.5), equals('-50%'));
        });
      });
    },
  );
}
