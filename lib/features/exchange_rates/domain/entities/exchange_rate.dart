import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  final String code; // USD, EUR, GBP, SAR, JPY
  final String name; // US Dollar, Euro, etc.
  final String flag; // Emoji flag 🇺🇸, 🇪🇺, 🇬🇧, 🇸🇦, 🇯🇵
  final double rate; // Inverted rate: 1 Foreign = X EGP
  final double change; // Absolute difference compared to previous day
  final double percentageChange; // Percentage change
  final bool isStrengthening; // True if EGP strengthened (meaning foreign rate decreased)
  final List<double> sparklineData; // 7-day trend values (inverted)
  final DateTime lastUpdated;

  const ExchangeRate({
    required this.code,
    required this.name,
    required this.flag,
    required this.rate,
    required this.change,
    required this.percentageChange,
    required this.isStrengthening,
    required this.sparklineData,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        code,
        name,
        flag,
        rate,
        change,
        percentageChange,
        isStrengthening,
        sparklineData,
        lastUpdated,
      ];
}
