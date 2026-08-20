import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exchange_rate.dart';

abstract class ExchangeRepository {
  /// Fetches the latest 5 currencies rates along with 24h change and sparkline trend
  Future<Either<Failure, List<ExchangeRate>>> getLatestRates();

  /// Fetches historical inverted rates for a specific currency over the past 7 days
  Future<Either<Failure, List<double>>> getHistoricalRates(String currencyCode);

  /// Returns the timestamp when the local cache was last updated
  Future<DateTime?> getLastCacheTimestamp();
}
