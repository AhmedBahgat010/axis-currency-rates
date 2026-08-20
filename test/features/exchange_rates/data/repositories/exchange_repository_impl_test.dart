import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_axis/core/error/exceptions.dart';
import 'package:task_axis/core/error/failures.dart';
import 'package:task_axis/core/network/network_info.dart';
import 'package:task_axis/features/exchange_rates/data/datasources/exchange_local_datasource.dart';
import 'package:task_axis/features/exchange_rates/data/datasources/exchange_remote_datasource.dart';
import 'package:task_axis/features/exchange_rates/data/repositories/exchange_repository_impl.dart';
import 'package:task_axis/features/exchange_rates/domain/entities/exchange_rate.dart';

class MockRemoteDataSource extends Mock implements ExchangeRemoteDataSource {}
class MockLocalDataSource extends Mock implements ExchangeLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ExchangeRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ExchangeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tExchangeRate = ExchangeRate(
    code: 'USD',
    name: 'US Dollar',
    flag: '🇺🇸',
    rate: 52.0,
    change: 0.1,
    percentageChange: 0.2,
    isStrengthening: false,
    sparklineData: const [51.8, 51.9, 52.0],
    lastUpdated: DateTime(2026, 8, 20),
  );
  final tRatesList = [tExchangeRate];

  group('getLatestRates', () {
    test('when device is online, should fetch from remote and cache locally', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getLatestRates()).thenAnswer((_) async => tRatesList);
      when(() => mockLocalDataSource.cacheLatestRates(tRatesList)).thenAnswer((_) async => {});

      // Act
      final result = await repository.getLatestRates();

      verify(() => mockRemoteDataSource.getLatestRates()).called(1);
      verify(() => mockLocalDataSource.cacheLatestRates(tRatesList)).called(1);
      expect(result, Right(tRatesList));
    });

    test('when device is online but remote call fails, should fallback to cache', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getLatestRates()).thenThrow(const ServerException('Network down'));
      when(() => mockLocalDataSource.getCachedLatestRates()).thenAnswer((_) async => tRatesList);

      final result = await repository.getLatestRates();
      expect(result, Right(tRatesList));
    });

    test('when device is offline, should return cached data directly', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedLatestRates()).thenAnswer((_) async => tRatesList);
      final result = await repository.getLatestRates();
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, Right(tRatesList));
    });

    test('when device is offline and cache is empty, should return CacheFailure', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedLatestRates()).thenThrow(const CacheException('No data'));
      final result = await repository.getLatestRates();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
