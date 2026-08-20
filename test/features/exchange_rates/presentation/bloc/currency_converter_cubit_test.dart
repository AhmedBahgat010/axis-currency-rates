import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_axis/core/network/network_info.dart';
import 'package:task_axis/features/exchange_rates/domain/entities/exchange_rate.dart';
import 'package:task_axis/features/exchange_rates/domain/usecases/get_latest_rates.dart';
import 'package:task_axis/features/exchange_rates/presentation/bloc/currency_converter/currency_converter_cubit.dart';

class MockGetLatestRates extends Mock implements GetLatestRates {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CurrencyConverterCubit cubit;
  late MockGetLatestRates mockGetLatestRates;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockGetLatestRates = MockGetLatestRates();
    mockNetworkInfo = MockNetworkInfo();

    cubit = CurrencyConverterCubit(
      getLatestRates: mockGetLatestRates,
      networkInfo: mockNetworkInfo,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tUsdRate = ExchangeRate(
    code: 'USD',
    name: 'US Dollar',
    flag: '🇺🇸',
    rate: 50.0,
    change: 0.1,
    percentageChange: 0.2,
    isStrengthening: false,
    sparklineData: const [],
    lastUpdated: DateTime(2026, 8, 20),
  );

  final tEurRate = ExchangeRate(
    code: 'EUR',
    name: 'Euro',
    flag: '🇪🇺',
    rate: 55.0,
    change: 0.2,
    percentageChange: 0.3,
    isStrengthening: false,
    sparklineData: const [],
    lastUpdated: DateTime(2026, 8, 20),
  );

  final tRates = [tUsdRate, tEurRate];

  test('loadRates populates rates and sets EGP to USD conversion', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockGetLatestRates()).thenAnswer((_) async => Right(tRates));

    await cubit.loadRates();

    expect(cubit.state.isLoading, false);
    expect(cubit.state.fromCurrency.code, 'EGP');
    expect(cubit.state.toCurrency.code, 'USD');
    expect(cubit.state.fromAmountText, '');
    expect(cubit.state.toAmountText, '');
  });

  test('onFromAmountChanged updates toAmountText in real time', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockGetLatestRates()).thenAnswer((_) async => Right(tRates));

    await cubit.loadRates();

    cubit.onFromAmountChanged('100');

    expect(cubit.state.fromAmountText, '100');
    expect(cubit.state.toAmountText, '2');
  });

  test('onToAmountChanged performs reverse conversion', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockGetLatestRates()).thenAnswer((_) async => Right(tRates));

    await cubit.loadRates();

    cubit.onToAmountChanged('10');

    expect(cubit.state.toAmountText, '10');
    expect(cubit.state.fromAmountText, '500');
  });

  test('swapCurrencies swaps currencies and recalculates amount', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockGetLatestRates()).thenAnswer((_) async => Right(tRates));

    await cubit.loadRates();
    cubit.onFromAmountChanged('100');
    cubit.swapCurrencies();

    expect(cubit.state.fromCurrency.code, 'USD');
    expect(cubit.state.toCurrency.code, 'EGP');
    expect(cubit.state.fromAmountText, '100');
    expect(cubit.state.toAmountText, '5000');
  });

}
