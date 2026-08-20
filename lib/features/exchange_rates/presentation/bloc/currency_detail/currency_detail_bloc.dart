import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_historical_rates.dart';
import 'currency_detail_event.dart';
import 'currency_detail_state.dart';

class CurrencyDetailBloc extends Bloc<CurrencyDetailEvent, CurrencyDetailState> {
  final GetHistoricalRates getHistoricalRates;

  CurrencyDetailBloc({required this.getHistoricalRates}) : super(CurrencyDetailInitial()) {
    on<FetchCurrencyHistoryEvent>(_onFetchHistory);
  }

  Future<void> _onFetchHistory(
    FetchCurrencyHistoryEvent event,
    Emitter<CurrencyDetailState> emit,
  ) async {
    emit(HistoryLoading());
    final result = await getHistoricalRates(event.currencyCode);
    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (history) => emit(HistoryLoaded(history)),
    );
  }
}
