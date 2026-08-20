import 'package:flutter_test/flutter_test.dart';
import 'package:task_axis/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('invertRate calculates 1 / rate correctly', () {
      // 1 EGP = 0.02 USD => 1 USD = 50.0 EGP
      final inverted = CurrencyFormatter.invertRate(0.02);
      expect(inverted, 50.0);
    });

    test('invertRate handles 0.0 without crash', () {
      final inverted = CurrencyFormatter.invertRate(0.0);
      expect(inverted, 0.0);
    });

    test('formatRate formats decimal places correctly', () {
      expect(CurrencyFormatter.formatRate(50.123456, decimals: 4), '50.1235');
      expect(CurrencyFormatter.formatRate(50.1, decimals: 2), '50.10');
    });

    test('formatDelta adds plus sign for positive values', () {
      expect(CurrencyFormatter.formatDelta(0.45), '+0.4500');
      expect(CurrencyFormatter.formatDelta(-0.45), '-0.4500');
    });

    test('formatPercent adds percentage and sign correctly', () {
      expect(CurrencyFormatter.formatPercent(1.234), '+1.23%');
      expect(CurrencyFormatter.formatPercent(-0.567), '-0.57%');
    });
  });
}
