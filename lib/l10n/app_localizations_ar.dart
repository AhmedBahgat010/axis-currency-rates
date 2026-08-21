// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سيرنسي أكسيس';

  @override
  String get baseCurrencySubtitle => 'العملة الأساسية: الجنيه المصري (ج.م)';

  @override
  String get marketRates => 'أسعار السوق';

  @override
  String get quickConverter => 'محول العملات السريع';

  @override
  String get exchangeRate => 'سعر الصرف';

  @override
  String get lastUpdated => 'آخر تحديث';

  @override
  String updatedAt(String date) {
    return 'تم التحديث $date';
  }

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get source => 'المصدر';

  @override
  String get target => 'الهدف';

  @override
  String get selectCurrency => 'اختر العملة';

  @override
  String get searchCurrency => 'ابحث عن كود العملة أو اسمها...';

  @override
  String get noCurrenciesFound => 'لم يتم العثور على عملات';

  @override
  String showingCachedRatesFrom(String date) {
    return 'عرض الأسعار المخزنة بتاريخ $date';
  }

  @override
  String get offlineMode => 'وضع عدم الاتصال';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errorTitle => 'حدث خطأ ما';

  @override
  String get priceAction7Days => 'حركة السعر خلال 7 أيام';

  @override
  String get interactiveChart => 'رسم بياني تفاعلي';

  @override
  String get change24h => 'التغير خلال 24 ساعة';

  @override
  String get highestRate => 'أعلى سعر';

  @override
  String get lowestRate => 'أقل سعر';

  @override
  String get averageRate => 'المتوسط';

  @override
  String get egpStrengthened => 'ارتفاع الجنيه المصري';

  @override
  String get egpWeakened => 'انخفاض الجنيه المصري';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get currentRate => 'السعر الحالي';

  @override
  String get convert => 'تحويل';

  @override
  String get egpName => 'الجنيه المصري';

  @override
  String get usdName => 'الدولار الأمريكي';

  @override
  String get eurName => 'اليورو';

  @override
  String get gbpName => 'الجنيه الإسترليني';

  @override
  String get sarName => 'الريال السعودي';

  @override
  String get jpyName => 'الين الياباني';

  @override
  String get egpSymbol => 'ج.م';

  @override
  String get usdSymbol => 'د.أ';

  @override
  String get eurSymbol => 'يورو';

  @override
  String get gbpSymbol => 'ج.إ';

  @override
  String get sarSymbol => 'ر.س';

  @override
  String get jpySymbol => 'ين';
}
