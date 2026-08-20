import 'package:hive/hive.dart';

part 'historical_rate_hive.g.dart';

@HiveType(typeId: 1)
class HistoricalRateHive extends HiveObject {
  @HiveField(0)
  late String currencyCode;

  @HiveField(1)
  late List<double> rates;

  @HiveField(2)
  late DateTime cachedAt;
}
