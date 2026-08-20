import 'package:equatable/equatable.dart';
import '../../../domain/entities/exchange_rate.dart';

abstract class RatesListEvent extends Equatable {
  const RatesListEvent();

  @override
  List<Object?> get props => [];
}

class FetchRatesEvent extends RatesListEvent {
  final bool isRefresh;
  const FetchRatesEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class ConnectivityRestoredEvent extends RatesListEvent {
  const ConnectivityRestoredEvent();
}
