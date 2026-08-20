import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_axis/core/network/network_info.dart';
import 'package:task_axis/features/exchange_rates/data/datasources/exchange_local_datasource.dart';
import 'package:task_axis/features/exchange_rates/data/datasources/exchange_remote_datasource.dart';
import 'package:task_axis/features/exchange_rates/data/models/exchange_rate_hive.dart';
import 'package:task_axis/features/exchange_rates/data/models/historical_rate_hive.dart';
import 'package:task_axis/features/exchange_rates/data/repositories/exchange_repository_impl.dart';
import 'package:task_axis/features/exchange_rates/domain/repositories/exchange_repository.dart';
import 'package:task_axis/features/exchange_rates/domain/usecases/get_historical_rates.dart';
import 'package:task_axis/features/exchange_rates/domain/usecases/get_latest_rates.dart';
import 'package:task_axis/features/exchange_rates/presentation/bloc/currency_detail/currency_detail_bloc.dart';
import 'package:task_axis/features/exchange_rates/presentation/bloc/rates_list/rates_list_bloc.dart';

import '../networking/api_service.dart' show ApiService;
import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ── Hive ─────────────────────────────────────────────────────────────────
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(ExchangeRateHiveAdapter().typeId)) {
    Hive.registerAdapter(ExchangeRateHiveAdapter());
  }
  if (!Hive.isAdapterRegistered(HistoricalRateHiveAdapter().typeId)) {
    Hive.registerAdapter(HistoricalRateHiveAdapter());
  }

  final ratesBox = await Hive.openBox<ExchangeRateHive>('exchange_rates');
  final historyBox = await Hive.openBox<HistoricalRateHive>('historical_rates');

  // ── Dio & Network ─────────────────────────────────────────────────────────
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt<Connectivity>()));

  // ── ApiService ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // ── Data Sources ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ExchangeRemoteDataSource>(
      () => ExchangeRemoteDataSourceImpl(getIt<ApiService>()));
  getIt.registerLazySingleton<ExchangeLocalDataSource>(
    () => ExchangeLocalDataSourceImpl(
      ratesBox: ratesBox,
      historyBox: historyBox,
    ),
  );

  // ── Repository ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ExchangeRepository>(() => ExchangeRepositoryImpl(
        remoteDataSource: getIt<ExchangeRemoteDataSource>(),
        localDataSource: getIt<ExchangeLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));

  // ── Use Cases ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<GetLatestRates>(() => GetLatestRates(getIt<ExchangeRepository>()));
  getIt.registerLazySingleton<GetHistoricalRates>(() => GetHistoricalRates(getIt<ExchangeRepository>()));

  // ── Blocs ─────────────────────────────────────────────────────────────────
  getIt.registerFactory<RatesListBloc>(() => RatesListBloc(
        getLatestRates: getIt<GetLatestRates>(),
        networkInfo: getIt<NetworkInfo>(),
      ));
  getIt.registerFactory<CurrencyDetailBloc>(() => CurrencyDetailBloc(
        getHistoricalRates: getIt<GetHistoricalRates>(),
      ));
}

