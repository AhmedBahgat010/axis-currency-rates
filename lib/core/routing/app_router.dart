import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_axis/core/routing/routes.dart';
import 'package:task_axis/features/exchange_rates/domain/entities/exchange_rate.dart';
import 'package:task_axis/features/exchange_rates/presentation/bloc/currency_detail/currency_detail_bloc.dart';
import 'package:task_axis/features/exchange_rates/presentation/bloc/rates_list/rates_list_bloc.dart';
import 'package:task_axis/features/exchange_rates/presentation/screens/currency_detail_screen.dart';
import 'package:task_axis/features/exchange_rates/presentation/screens/exchange_rates_list_screen.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.exchangeRatesList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<RatesListBloc>(),
            child: const ExchangeRatesListScreen(),
          ),
        );
      case Routes.currencyDetail:
        final rate = arguments as ExchangeRate;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<CurrencyDetailBloc>(),
            child: CurrencyDetailScreen(exchangeRate: rate),
          ),
        );
      default:
        return null;
    }
  }
}
