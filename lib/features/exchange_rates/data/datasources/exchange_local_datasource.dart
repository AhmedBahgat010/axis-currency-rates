import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/exchange_rate.dart';
import '../models/exchange_rate_hive.dart';
import '../models/historical_rate_hive.dart';

abstract class ExchangeLocalDataSource {
  Future<void> cacheLatestRates(List<ExchangeRate> rates);
  Future<List<ExchangeRate>> getCachedLatestRates();
  Future<void> cacheHistoricalRates(String currencyCode, List<double> rates);
  Future<List<double>> getCachedHistoricalRates(String currencyCode);
  Future<DateTime?> getLastCacheTimestamp();
}

class ExchangeLocalDataSourceImpl implements ExchangeLocalDataSource {
  final Box<ExchangeRateHive> ratesBox;
  final Box<HistoricalRateHive> historyBox;

  ExchangeLocalDataSourceImpl({
    required this.ratesBox,
    required this.historyBox,
  });

  // ────────────────────────────────────────────────
  // Latest Rates
  // ────────────────────────────────────────────────

  @override
  Future<void> cacheLatestRates(List<ExchangeRate> rates) async {
    try {
      final now = DateTime.now();
      await ratesBox.clear();
      final hiveRates = rates.map((r) {
        return ExchangeRateHive()
          ..code = r.code
          ..name = r.name
          ..flag = r.flag
          ..rate = r.rate
          ..change = r.change
          ..percentageChange = r.percentageChange
          ..isStrengthening = r.isStrengthening
          ..sparklineData = List<double>.from(r.sparklineData)
          ..lastUpdated = r.lastUpdated
          ..cachedAt = now;
      }).toList();
      await ratesBox.addAll(hiveRates);

      for (final r in rates) {
        if (r.sparklineData.isNotEmpty) {
          final key = r.code.toUpperCase();
          await historyBox.put(
            key,
            HistoricalRateHive()
              ..currencyCode = key
              ..rates = List<double>.from(r.sparklineData)
              ..cachedAt = now,
          );
        }
      }
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<ExchangeRate>> getCachedLatestRates() async {
    try {
      final records = ratesBox.values.toList();
      if (records.isEmpty) {
        throw const CacheException('No cached exchange rates found');
      }
      return records.map((h) {
        return ExchangeRate(
          code: h.code,
          name: h.name,
          flag: h.flag,
          rate: h.rate,
          change: h.change,
          percentageChange: h.percentageChange,
          isStrengthening: h.isStrengthening,
          sparklineData: List<double>.from(h.sparklineData),
          lastUpdated: h.lastUpdated,
        );
      }).toList();
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  // ────────────────────────────────────────────────
  // Historical Rates (keyed by currency code)
  // ────────────────────────────────────────────────

  @override
  Future<void> cacheHistoricalRates(
      String currencyCode, List<double> rates) async {
    try {
      final key = currencyCode.toUpperCase();
      final existing = historyBox.get(key);
      if (existing != null) {
        existing
          ..rates = List<double>.from(rates)
          ..cachedAt = DateTime.now();
        await existing.save();
      } else {
        await historyBox.put(
          key,
          HistoricalRateHive()
            ..currencyCode = key
            ..rates = List<double>.from(rates)
            ..cachedAt = DateTime.now(),
        );
      }
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<double>> getCachedHistoricalRates(String currencyCode) async {
    try {
      final key = currencyCode.toUpperCase();
      final record = historyBox.get(key);
      if (record == null || record.rates.isEmpty) {
        throw const CacheException('No cached historical rates found');
      }
      return List<double>.from(record.rates);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  // ────────────────────────────────────────────────
  // Timestamp
  // ────────────────────────────────────────────────

  @override
  Future<DateTime?> getLastCacheTimestamp() async {
    try {
      if (ratesBox.isEmpty) return null;
      return ratesBox.values
          .map((h) => h.cachedAt)
          .reduce((a, b) => a.isAfter(b) ? a : b);
    } catch (_) {
      return null;
    }
  }
}

