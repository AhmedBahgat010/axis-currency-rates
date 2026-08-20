import 'package:hive/hive.dart';

part 'exchange_rate_hive.g.dart';

@HiveType(typeId: 0)
class ExchangeRateHive extends HiveObject {
  @HiveField(0)
  late String code;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String flag;

  @HiveField(3)
  late double rate;

  @HiveField(4)
  late double change;

  @HiveField(5)
  late double percentageChange;

  @HiveField(6)
  late bool isStrengthening;

  @HiveField(7)
  late List<double> sparklineData;

  @HiveField(8)
  late DateTime lastUpdated;

  @HiveField(9)
  late DateTime cachedAt;
}
