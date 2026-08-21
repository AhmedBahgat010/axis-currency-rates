import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/exchange_rate.dart';

abstract class ExchangeRemoteDataSource {
  Future<List<ExchangeRate>> getLatestRates();
  Future<List<double>> getHistoricalRates(String currencyCode);
}

class ExchangeRemoteDataSourceImpl implements ExchangeRemoteDataSource {
  final ApiService apiService;
  final Map<String, Map<String, dynamic>> _dateCache = {};

  ExchangeRemoteDataSourceImpl(this.apiService);

  static const List<Map<String, String>> targetCurrencies = [
    {'code': 'USD', 'name': 'US Dollar', 'flag': '🇺🇸'},
    {'code': 'EUR', 'name': 'Euro', 'flag': '🇪🇺'},
    {'code': 'GBP', 'name': 'British Pound', 'flag': '🇬🇧'},
    {'code': 'SAR', 'name': 'Saudi Riyal', 'flag': '🇸🇦'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'flag': '🇯🇵'},
  ];

  @override
  Future<List<ExchangeRate>> getLatestRates() async {
    try {
      // Fetch latest EGP rates
      final latestData = await apiService.getLatestRates();

      final dynamic egpLatestMap = latestData['egp'];
      if (egpLatestMap == null || egpLatestMap is! Map<String, dynamic>) {
        throw const ParsingException('Malformed latest currency response');
      }

      final String dateStr = latestData['date'] ?? DateTime.now().toIso8601String();
      final DateTime latestDate = DateTime.tryParse(dateStr) ?? DateTime.now();

      // Fetch past 7 days for sparklines & 24h change
      final List<DateTime> pastDates = [];
      for (int i = 1; i <= 7; i++) {
        pastDates.add(latestDate.subtract(Duration(days: i)));
      }

      final historicalFutures = pastDates.map((date) {
        final dateKey = CurrencyFormatter.formatDateKey(date);
        if (_dateCache.containsKey(dateKey)) {
          return Future.value(_dateCache[dateKey]);
        }
        return apiService.getHistoricalRates(dateKey).then<Map<String, dynamic>?>((res) {
          if (res['egp'] is Map<String, dynamic>) {
            final map = Map<String, dynamic>.from(res['egp']);
            _dateCache[dateKey] = map;
            return map;
          }
          return null;
        }).catchError((_) => null);
      }).toList();

      final List<Map<String, dynamic>?> pastDaysEgpMaps = await Future.wait(historicalFutures);

      final List<ExchangeRate> rates = [];

      for (final currency in targetCurrencies) {
        final codeLower = currency['code']!.toLowerCase();
        final rawLatest = (egpLatestMap[codeLower] as num?)?.toDouble();

        if (rawLatest == null || rawLatest == 0.0) {
          continue;
        }

        final currentInvertedRate = CurrencyFormatter.invertRate(rawLatest);

        // Build 7-day sparkline
        final List<double> sparkline = [];
        for (int i = pastDaysEgpMaps.length - 1; i >= 0; i--) {
          final pastMap = pastDaysEgpMaps[i];
          if (pastMap != null && pastMap[codeLower] != null) {
            final pastRaw = (pastMap[codeLower] as num).toDouble();
            sparkline.add(CurrencyFormatter.invertRate(pastRaw));
          } else {
            sparkline.add(currentInvertedRate);
          }
        }
        sparkline.add(currentInvertedRate);

        // Calculate 24h change
        double prevInvertedRate = currentInvertedRate;
        if (pastDaysEgpMaps.isNotEmpty && pastDaysEgpMaps[0] != null && pastDaysEgpMaps[0]![codeLower] != null) {
          final prevRaw = (pastDaysEgpMaps[0]![codeLower] as num).toDouble();
          prevInvertedRate = CurrencyFormatter.invertRate(prevRaw);
        }

        final double delta = currentInvertedRate - prevInvertedRate;
        final double percentage = prevInvertedRate != 0.0 ? (delta / prevInvertedRate) * 100 : 0.0;
        
        // EGP strengthened if foreign rate dropped
        final bool isStrengthening = delta <= 0;

        rates.add(ExchangeRate(
          code: currency['code']!,
          name: currency['name']!,
          flag: currency['flag']!,
          rate: currentInvertedRate,
          change: delta,
          percentageChange: percentage,
          isStrengthening: isStrengthening,
          sparklineData: sparkline,
          lastUpdated: DateTime.now(),
        ));
      }

      return rates;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server network error');
    } catch (e) {
      if (e is ServerException || e is ParsingException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<double>> getHistoricalRates(String currencyCode) async {
    try {
      final codeLower = currencyCode.toLowerCase();
      final now = DateTime.now();
      final List<DateTime> dates = [];
      for (int i = 6; i >= 0; i--) {
        dates.add(now.subtract(Duration(days: i)));
      }

      final futures = dates.map((date) {
        final dateKey = CurrencyFormatter.formatDateKey(date);
        if (_dateCache.containsKey(dateKey)) {
          final cached = _dateCache[dateKey]!;
          final raw = (cached[codeLower] as num?)?.toDouble();
          if (raw != null && raw > 0) {
            return Future.value(CurrencyFormatter.invertRate(raw));
          }
        }
        return apiService.getHistoricalRates(dateKey).then<double?>((res) {
          if (res['egp'] is Map<String, dynamic>) {
            final map = Map<String, dynamic>.from(res['egp']);
            _dateCache[dateKey] = map;
            final raw = (map[codeLower] as num?)?.toDouble();
            if (raw != null && raw > 0) {
              return CurrencyFormatter.invertRate(raw);
            }
          }
          return null;
        }).catchError((_) => null);
      }).toList();

      final List<double?> results = await Future.wait(futures);
      final List<double> cleanRates = [];
      double lastKnown = 50.0;

      for (final r in results) {
        if (r != null) {
          lastKnown = r;
          cleanRates.add(r);
        } else {
          cleanRates.add(lastKnown);
        }
      }

      return cleanRates;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch historical rates');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
