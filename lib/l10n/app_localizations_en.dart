// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Currency Axis';

  @override
  String get baseCurrencySubtitle => 'Base: Egyptian Pound (EGP)';

  @override
  String get marketRates => 'MARKET RATES';

  @override
  String get quickConverter => 'QUICK CONVERTER';

  @override
  String get exchangeRate => 'EXCHANGE RATE';

  @override
  String get lastUpdated => 'LAST UPDATED';

  @override
  String updatedAt(String date) {
    return 'Updated $date';
  }

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get source => 'SOURCE';

  @override
  String get target => 'TARGET';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get searchCurrency => 'Search currency code or name...';

  @override
  String get noCurrenciesFound => 'No currencies found';

  @override
  String showingCachedRatesFrom(String date) {
    return 'Showing cached rates from $date';
  }

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get retry => 'Retry';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get priceAction7Days => '7-Day Price Action';

  @override
  String get interactiveChart => 'Interactive Chart';

  @override
  String get change24h => '24h Change';

  @override
  String get highestRate => 'Highest Rate';

  @override
  String get lowestRate => 'Lowest Rate';

  @override
  String get averageRate => 'Average Rate';

  @override
  String get egpStrengthened => 'EGP Strengthened';

  @override
  String get egpWeakened => 'EGP Weakened';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get currentRate => 'Current Rate';

  @override
  String get convert => 'Convert';

  @override
  String get egpName => 'Egyptian Pound';

  @override
  String get usdName => 'US Dollar';

  @override
  String get eurName => 'Euro';

  @override
  String get gbpName => 'British Pound';

  @override
  String get sarName => 'Saudi Riyal';

  @override
  String get jpyName => 'Japanese Yen';

  @override
  String get egpSymbol => 'EGP';

  @override
  String get usdSymbol => 'USD';

  @override
  String get eurSymbol => 'EUR';

  @override
  String get gbpSymbol => 'GBP';

  @override
  String get sarSymbol => 'SAR';

  @override
  String get jpySymbol => 'JPY';
}
