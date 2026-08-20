import 'package:equatable/equatable.dart';
import '../../../domain/entities/exchange_rate.dart';

class CurrencyConverterState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<ExchangeRate> availableRates;
  final ExchangeRate fromCurrency;
  final ExchangeRate toCurrency;
  final String fromAmountText;
  final String toAmountText;
  final DateTime? lastUpdated;
  final bool isOffline;
  final bool lastEditedIsFrom;

  const CurrencyConverterState({
    required this.isLoading,
    this.errorMessage,
    required this.availableRates,
    required this.fromCurrency,
    required this.toCurrency,
    required this.fromAmountText,
    required this.toAmountText,
    this.lastUpdated,
    required this.isOffline,
    this.lastEditedIsFrom = true,
  });

  /// Factory initial state
  factory CurrencyConverterState.initial() {
    final now = DateTime.now();
    final egp = ExchangeRate(
      code: 'EGP',
      name: 'Egyptian Pound',
      flag: '🇪🇬',
      rate: 1.0,
      change: 0.0,
      percentageChange: 0.0,
      isStrengthening: true,
      sparklineData: const [],
      lastUpdated: now,
    );
    final usd = ExchangeRate(
      code: 'USD',
      name: 'US Dollar',
      flag: '🇺🇸',
      rate: 48.5,
      change: 0.0,
      percentageChange: 0.0,
      isStrengthening: true,
      sparklineData: const [],
      lastUpdated: now,
    );

    return CurrencyConverterState(
      isLoading: true,
      errorMessage: null,
      availableRates: [egp, usd],
      fromCurrency: egp,
      toCurrency: usd,
      fromAmountText: '1',
      toAmountText: '',
      lastUpdated: now,
      isOffline: false,
      lastEditedIsFrom: true,
    );
  }

  /// Calculates rate: 1 Unit of From = X Units of To
  double get currentExchangeRate {
    if (toCurrency.rate == 0.0) return 0.0;
    return fromCurrency.rate / toCurrency.rate;
  }

  CurrencyConverterState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ExchangeRate>? availableRates,
    ExchangeRate? fromCurrency,
    ExchangeRate? toCurrency,
    String? fromAmountText,
    String? toAmountText,
    DateTime? lastUpdated,
    bool? isOffline,
    bool? lastEditedIsFrom,
  }) {
    return CurrencyConverterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      availableRates: availableRates ?? this.availableRates,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      fromAmountText: fromAmountText ?? this.fromAmountText,
      toAmountText: toAmountText ?? this.toAmountText,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isOffline: isOffline ?? this.isOffline,
      lastEditedIsFrom: lastEditedIsFrom ?? this.lastEditedIsFrom,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        availableRates,
        fromCurrency,
        toCurrency,
        fromAmountText,
        toAmountText,
        lastUpdated,
        isOffline,
        lastEditedIsFrom,
      ];
}
