import '../../domain/entities/exchange_rate.dart';

class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.code,
    required super.name,
    required super.flag,
    required super.rate,
    required super.change,
    required super.percentageChange,
    required super.isStrengthening,
    required super.sparklineData,
    required super.lastUpdated,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      flag: json['flag'] ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      change: (json['change'] as num?)?.toDouble() ?? 0.0,
      percentageChange: (json['percentageChange'] as num?)?.toDouble() ?? 0.0,
      isStrengthening: json['isStrengthening'] ?? false,
      sparklineData: (json['sparklineData'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      lastUpdated: DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'flag': flag,
      'rate': rate,
      'change': change,
      'percentageChange': percentageChange,
      'isStrengthening': isStrengthening,
      'sparklineData': sparklineData,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory ExchangeRateModel.fromEntity(ExchangeRate entity) {
    return ExchangeRateModel(
      code: entity.code,
      name: entity.name,
      flag: entity.flag,
      rate: entity.rate,
      change: entity.change,
      percentageChange: entity.percentageChange,
      isStrengthening: entity.isStrengthening,
      sparklineData: entity.sparklineData,
      lastUpdated: entity.lastUpdated,
    );
  }
}
