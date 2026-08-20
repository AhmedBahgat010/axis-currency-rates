import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/exchange_repository.dart';
import '../datasources/exchange_local_datasource.dart';
import '../datasources/exchange_remote_datasource.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;
  final ExchangeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ExchangeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ExchangeRate>>> getLatestRates() async {
    final bool isOnline = await networkInfo.isConnected;

    if (isOnline) {
      try {
        final remoteRates = await remoteDataSource.getLatestRates();
        // Fetch fresh rates & update cache
        await localDataSource.cacheLatestRates(remoteRates);
        return Right(remoteRates);
      } catch (e) {
        // Fallback to cache if API fails
        try {
          final cachedRates = await localDataSource.getCachedLatestRates();
          return Right(cachedRates);
        } catch (_) {
          return Left(ServerFailure(e.toString()));
        }
      }
    } else {
      // Offline: serve cached rates
      try {
        final cachedRates = await localDataSource.getCachedLatestRates();
        return Right(cachedRates);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<double>>> getHistoricalRates(String currencyCode) async {
    // Try local cache first
    try {
      final cachedHistory = await localDataSource.getCachedHistoricalRates(currencyCode);
      if (cachedHistory.isNotEmpty) {
        return Right(cachedHistory);
      }
    } catch (_) {}

    // Fallback to network
    final bool isOnline = await networkInfo.isConnected;
    if (isOnline) {
      try {
        final remoteHistory = await remoteDataSource.getHistoricalRates(currencyCode);
        await localDataSource.cacheHistoricalRates(currencyCode, remoteHistory);
        return Right(remoteHistory);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(CacheFailure('No cached historical rates found'));
    }
  }

  @override
  Future<DateTime?> getLastCacheTimestamp() async {
    return await localDataSource.getLastCacheTimestamp();
  }
}
