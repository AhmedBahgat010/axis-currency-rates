import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_axis/core/error/failures.dart';
import 'package:task_axis/core/network/network_info.dart';
import 'package:task_axis/features/exchange_rates/domain/entities/exchange_rate.dart';
import 'package:task_axis/features/exchange_rates/domain/usecases/get_latest_rates.dart';
import 'package:task_axis/features/exchange_rates/presentation/bloc/rates_list/rates_list_bloc.dart';
import 'package:task_axis/features/exchange_rates/presentation/bloc/rates_list/rates_list_event.dart';
import 'package:task_axis/features/exchange_rates/presentation/bloc/rates_list/rates_list_state.dart';

class MockGetLatestRates extends Mock implements GetLatestRates {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late RatesListBloc bloc;
  late MockGetLatestRates mockGetLatestRates;
  late MockNetworkInfo mockNetworkInfo;
  late StreamController<List<ConnectivityResult>> connectivityController;

  setUp(() {
    mockGetLatestRates = MockGetLatestRates();
    mockNetworkInfo = MockNetworkInfo();
    connectivityController = StreamController<List<ConnectivityResult>>.broadcast();

    when(() => mockNetworkInfo.onConnectivityChanged)
        .thenAnswer((_) => connectivityController.stream);

    bloc = RatesListBloc(
      getLatestRates: mockGetLatestRates,
      networkInfo: mockNetworkInfo,
    );
  });

  tearDown(() {
    connectivityController.close();
    bloc.close();
  });

  final tRate = ExchangeRate(
    code: 'USD',
    name: 'US Dollar',
    flag: '🇺🇸',
    rate: 52.0,
    change: 0.1,
    percentageChange: 0.2,
    isStrengthening: false,
    sparklineData: const [51.8, 52.0],
    lastUpdated: DateTime(2026, 8, 20),
  );
  final tRatesList = [tRate];

  test('initial state should be RatesListInitial', () {
    expect(bloc.state, isA<RatesListInitial>());
  });

  test('emits [RatesListLoading, RatesListLoaded] when FetchRatesEvent is added and online', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockGetLatestRates()).thenAnswer((_) async => Right(tRatesList));

    final expectedStates = [
      isA<RatesListLoading>(),
      isA<RatesListLoaded>().having((s) => s.rates, 'rates', tRatesList),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(const FetchRatesEvent());
  });

  test('emits [RatesListLoading, RatesListLoadedFromCache] when FetchRatesEvent is added and offline', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    when(() => mockGetLatestRates()).thenAnswer((_) async => Right(tRatesList));

    final expectedStates = [
      isA<RatesListLoading>(),
      isA<RatesListLoadedFromCache>().having((s) => s.rates, 'rates', tRatesList),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(const FetchRatesEvent());
  });

  test('emits [RatesListLoading, RatesListError] when GetLatestRates fails', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockGetLatestRates()).thenAnswer((_) async => const Left(ServerFailure('API error')));

    final expectedStates = [
      isA<RatesListLoading>(),
      isA<RatesListError>().having((s) => s.message, 'message', 'API error'),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(const FetchRatesEvent());
  });
}
