import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_axis/core/network/network_info.dart';
import 'package:task_axis/features/exchange_rates/domain/entities/exchange_rate.dart';
import 'package:task_axis/features/exchange_rates/domain/usecases/get_latest_rates.dart';
import 'currency_converter_state.dart';

class CurrencyConverterCubit extends Cubit<CurrencyConverterState> {
  final GetLatestRates getLatestRates;
  final NetworkInfo networkInfo;

  CurrencyConverterCubit({
    required this.getLatestRates,
    required this.networkInfo,
  }) : super(CurrencyConverterState.initial());

  static final ExchangeRate egpCurrency = ExchangeRate(
    code: 'EGP',
    name: 'Egyptian Pound',
    flag: '🇪🇬',
    rate: 1.0,
    change: 0.0,
    percentageChange: 0.0,
    isStrengthening: true,
    sparklineData: const [],
    lastUpdated: DateTime.now(),
  );

  /// Load currency rates
  Future<void> loadRates({
    ExchangeRate? initialFrom,
    ExchangeRate? initialTo,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final isConnected = await networkInfo.isConnected;
    final result = await getLatestRates();

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (fetchedRates) {
        const allowedCurrencies = {'EGP', 'USD', 'EUR', 'SAR', 'JPY', 'GBP'};
        final List<ExchangeRate> allRates = [egpCurrency];
        for (final r in fetchedRates) {
          final code = r.code.toUpperCase();
          if (code != 'EGP' && allowedCurrencies.contains(code)) {
            allRates.add(r);
          }
        }


        ExchangeRate from = initialFrom ??
            allRates.firstWhere(
              (r) => r.code == 'EGP',
              orElse: () => egpCurrency,
            );
        ExchangeRate to = initialTo ??
            allRates.firstWhere(
              (r) => r.code == 'USD',
              orElse: () => allRates.length > 1 ? allRates[1] : egpCurrency,
            );

        final initialFromText = state.fromAmountText;
        final initialToText = initialFromText.trim().isEmpty
            ? ''
            : _calculateConversion(initialFromText, from, to);


        emit(state.copyWith(
          isLoading: false,
          availableRates: allRates,
          fromCurrency: from,
          toCurrency: to,
          fromAmountText: initialFromText,
          toAmountText: initialToText,
          lastUpdated: fetchedRates.isNotEmpty
              ? fetchedRates.first.lastUpdated
              : DateTime.now(),
          isOffline: !isConnected,
          lastEditedIsFrom: true,
        ));
      },
    );
  }

  /// Triggered when From text field amount changes
  void onFromAmountChanged(String value) {
    if (value.trim().isEmpty) {
      emit(state.copyWith(
        fromAmountText: '',
        toAmountText: '',
        lastEditedIsFrom: true,
      ));
      return;
    }

    final convertedTo = _calculateConversion(
      value,
      state.fromCurrency,
      state.toCurrency,
    );

    emit(state.copyWith(
      fromAmountText: value,
      toAmountText: convertedTo,
      lastEditedIsFrom: true,
    ));
  }

  /// Triggered when To text field amount changes (Reverse conversion)
  void onToAmountChanged(String value) {
    if (value.trim().isEmpty) {
      emit(state.copyWith(
        fromAmountText: '',
        toAmountText: '',
        lastEditedIsFrom: false,
      ));
      return;
    }

    final convertedFrom = _calculateConversion(
      value,
      state.toCurrency,
      state.fromCurrency,
    );

    emit(state.copyWith(
      fromAmountText: convertedFrom,
      toAmountText: value,
      lastEditedIsFrom: false,
    ));
  }

  /// Swaps From and To currencies instantly
  void swapCurrencies() {
    final newFrom = state.toCurrency;
    final newTo = state.fromCurrency;

    final newToText = _calculateConversion(
      state.fromAmountText,
      newFrom,
      newTo,
    );

    emit(state.copyWith(
      fromCurrency: newFrom,
      toCurrency: newTo,
      toAmountText: newToText,
    ));
  }

  /// Select a new From currency from picker
  void selectFromCurrency(ExchangeRate selected) {
    if (selected.code == state.fromCurrency.code) return;

    ExchangeRate newTo = state.toCurrency;
    if (selected.code == state.toCurrency.code) {
      newTo = state.fromCurrency;
    }

    final newToText = _calculateConversion(
      state.fromAmountText,
      selected,
      newTo,
    );

    emit(state.copyWith(
      fromCurrency: selected,
      toCurrency: newTo,
      toAmountText: newToText,
    ));
  }

  /// Select a new To currency from picker
  void selectToCurrency(ExchangeRate selected) {
    if (selected.code == state.toCurrency.code) return;

    ExchangeRate newFrom = state.fromCurrency;
    if (selected.code == state.fromCurrency.code) {
      newFrom = state.toCurrency;
    }

    final newToText = _calculateConversion(
      state.fromAmountText,
      newFrom,
      selected,
    );

    emit(state.copyWith(
      fromCurrency: newFrom,
      toCurrency: selected,
      toAmountText: newToText,
    ));
  }

  String _calculateConversion(
    String amountStr,
    ExchangeRate source,
    ExchangeRate target,
  ) {
    final cleanStr = amountStr.replaceAll(',', '');
    final double? amount = double.tryParse(cleanStr);
    if (amount == null || target.rate == 0.0) {
      return '';
    }

    final double result = amount * (source.rate / target.rate);
    return _formatAmount(result);
  }

  String _formatAmount(double val) {
    if (val == 0) return '0';
    String str;
    if (val.abs() >= 100) {
      str = val.toStringAsFixed(2);
    } else if (val.abs() >= 1) {
      str = val.toStringAsFixed(2);
    } else {
      str = val.toStringAsFixed(4);
    }
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return str;
  }
}
