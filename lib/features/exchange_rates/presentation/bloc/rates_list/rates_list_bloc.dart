import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/usecases/get_latest_rates.dart';
import 'rates_list_event.dart';
import 'rates_list_state.dart';

class RatesListBloc extends Bloc<RatesListEvent, RatesListState> {
  final GetLatestRates getLatestRates;
  final NetworkInfo networkInfo;
  StreamSubscription? _connectivitySubscription;

  RatesListBloc({
    required this.getLatestRates,
    required this.networkInfo,
  }) : super(RatesListInitial()) {
    on<FetchRatesEvent>(_onFetchRates);
    on<ConnectivityRestoredEvent>(_onConnectivityRestored);

    _connectivitySubscription = networkInfo.onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        add(const ConnectivityRestoredEvent());
      }
    });
  }

  Future<void> _onFetchRates(
    FetchRatesEvent event,
    Emitter<RatesListState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(RatesListLoading());
    }

    final isOnline = await networkInfo.isConnected;
    final result = await getLatestRates();

    result.fold(
      (failure) {
        emit(RatesListError(failure.message));
      },
      (rates) {
        final lastUpdated = rates.isNotEmpty ? rates.first.lastUpdated : DateTime.now();
        if (isOnline) {
          emit(RatesListLoaded(rates: rates, lastUpdated: lastUpdated));
        } else {
          emit(RatesListLoadedFromCache(rates: rates, lastUpdated: lastUpdated));
        }
      },
    );
  }

  Future<void> _onConnectivityRestored(
    ConnectivityRestoredEvent event,
    Emitter<RatesListState> emit,
  ) async {
    // When connectivity is regained, automatically trigger a refresh
    add(const FetchRatesEvent(isRefresh: true));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
