import 'package:equatable/equatable.dart';

abstract class CurrencyDetailState extends Equatable {
  const CurrencyDetailState();

  @override
  List<Object?> get props => [];
}

class CurrencyDetailInitial extends CurrencyDetailState {}

class HistoryLoading extends CurrencyDetailState {}

class HistoryLoaded extends CurrencyDetailState {
  final List<double> historicalRates;
  const HistoryLoaded(this.historicalRates);

  @override
  List<Object?> get props => [historicalRates];
}

class HistoryError extends CurrencyDetailState {
  final String message;
  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
