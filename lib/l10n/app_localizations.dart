import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency Axis'**
  String get appTitle;

  /// No description provided for @baseCurrencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Base: Egyptian Pound (EGP)'**
  String get baseCurrencySubtitle;

  /// No description provided for @marketRates.
  ///
  /// In en, this message translates to:
  /// **'MARKET RATES'**
  String get marketRates;

  /// No description provided for @quickConverter.
  ///
  /// In en, this message translates to:
  /// **'QUICK CONVERTER'**
  String get quickConverter;

  /// No description provided for @exchangeRate.
  ///
  /// In en, this message translates to:
  /// **'EXCHANGE RATE'**
  String get exchangeRate;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'LAST UPDATED'**
  String get lastUpdated;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String updatedAt(String date);

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'SOURCE'**
  String get source;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'TARGET'**
  String get target;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @searchCurrency.
  ///
  /// In en, this message translates to:
  /// **'Search currency code or name...'**
  String get searchCurrency;

  /// No description provided for @noCurrenciesFound.
  ///
  /// In en, this message translates to:
  /// **'No currencies found'**
  String get noCurrenciesFound;

  /// No description provided for @showingCachedRatesFrom.
  ///
  /// In en, this message translates to:
  /// **'Showing cached rates from {date}'**
  String showingCachedRatesFrom(String date);

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @priceAction7Days.
  ///
  /// In en, this message translates to:
  /// **'7-Day Price Action'**
  String get priceAction7Days;

  /// No description provided for @interactiveChart.
  ///
  /// In en, this message translates to:
  /// **'Interactive Chart'**
  String get interactiveChart;

  /// No description provided for @change24h.
  ///
  /// In en, this message translates to:
  /// **'24h Change'**
  String get change24h;

  /// No description provided for @highestRate.
  ///
  /// In en, this message translates to:
  /// **'Highest Rate'**
  String get highestRate;

  /// No description provided for @lowestRate.
  ///
  /// In en, this message translates to:
  /// **'Lowest Rate'**
  String get lowestRate;

  /// No description provided for @averageRate.
  ///
  /// In en, this message translates to:
  /// **'Average Rate'**
  String get averageRate;

  /// No description provided for @egpStrengthened.
  ///
  /// In en, this message translates to:
  /// **'EGP Strengthened'**
  String get egpStrengthened;

  /// No description provided for @egpWeakened.
  ///
  /// In en, this message translates to:
  /// **'EGP Weakened'**
  String get egpWeakened;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @currentRate.
  ///
  /// In en, this message translates to:
  /// **'Current Rate'**
  String get currentRate;

  /// No description provided for @convert.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get convert;

  /// No description provided for @egpName.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Pound'**
  String get egpName;

  /// No description provided for @usdName.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get usdName;

  /// No description provided for @eurName.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get eurName;

  /// No description provided for @gbpName.
  ///
  /// In en, this message translates to:
  /// **'British Pound'**
  String get gbpName;

  /// No description provided for @sarName.
  ///
  /// In en, this message translates to:
  /// **'Saudi Riyal'**
  String get sarName;

  /// No description provided for @jpyName.
  ///
  /// In en, this message translates to:
  /// **'Japanese Yen'**
  String get jpyName;

  /// No description provided for @egpSymbol.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egpSymbol;

  /// No description provided for @usdSymbol.
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get usdSymbol;

  /// No description provided for @eurSymbol.
  ///
  /// In en, this message translates to:
  /// **'EUR'**
  String get eurSymbol;

  /// No description provided for @gbpSymbol.
  ///
  /// In en, this message translates to:
  /// **'GBP'**
  String get gbpSymbol;

  /// No description provided for @sarSymbol.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get sarSymbol;

  /// No description provided for @jpySymbol.
  ///
  /// In en, this message translates to:
  /// **'JPY'**
  String get jpySymbol;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
