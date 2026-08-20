import 'package:equatable/equatable.dart';

abstract class CurrencyDetailEvent extends Equatable {
  const CurrencyDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchCurrencyHistoryEvent extends CurrencyDetailEvent {
  final String currencyCode;
  const FetchCurrencyHistoryEvent(this.currencyCode);

  @override
  List<Object?> get props => [currencyCode];
}
