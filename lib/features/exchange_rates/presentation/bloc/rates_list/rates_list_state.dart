import 'package:equatable/equatable.dart';
import '../../../domain/entities/exchange_rate.dart';

abstract class RatesListState extends Equatable {
  const RatesListState();

  @override
  List<Object?> get props => [];
}

class RatesListInitial extends RatesListState {}

class RatesListLoading extends RatesListState {}

class RatesListLoaded extends RatesListState {
  final List<ExchangeRate> rates;
  final DateTime lastUpdated;

  const RatesListLoaded({
    required this.rates,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [rates, lastUpdated];
}

class RatesListLoadedFromCache extends RatesListState {
  final List<ExchangeRate> rates;
  final DateTime lastUpdated;

  const RatesListLoadedFromCache({
    required this.rates,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [rates, lastUpdated];
}

class RatesListError extends RatesListState {
  final String message;
  const RatesListError(this.message);

  @override
  List<Object?> get props => [message];
}
