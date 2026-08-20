import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// Inverts rate to display 1 foreign = X EGP
  static double invertRate(double rateFromEgp) {
    if (rateFromEgp == 0.0) return 0.0;
    return 1.0 / rateFromEgp;
  }

  /// Formats rate as readable decimal
  static String formatRate(double rate, {int decimals = 4}) {
    return rate.toStringAsFixed(decimals);
  }

  /// Formats currency delta (+/-)
  static String formatDelta(double delta, {int decimals = 4}) {
    final prefix = delta > 0 ? '+' : '';
    return '$prefix${delta.toStringAsFixed(decimals)}';
  }

  /// Formats percentage change (+/- %)
  static String formatPercent(double percent) {
    final prefix = percent > 0 ? '+' : '';
    return '$prefix${percent.toStringAsFixed(2)}%';
  }

  /// Formats DateTime (e.g. Aug 20, 2026 04:30 PM)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
  }

  /// Formats Date to yyyy-MM-dd
  static String formatDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
