import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/exchange_rate.dart';
import 'sparkline.dart';

import 'package:task_axis/l10n/app_localizations.dart';

class RateCard extends StatelessWidget {
  final ExchangeRate rate;
  final VoidCallback onTap;

  const RateCard({super.key, required this.rate, required this.onTap});

  String _getLocalizedCurrencyName(
      BuildContext context, String code, String defaultName) {
    final l10n = AppLocalizations.of(context)!;
    switch (code.toUpperCase()) {
      case 'EGP':
        return l10n.egpName;
      case 'USD':
        return l10n.usdName;
      case 'EUR':
        return l10n.eurName;
      case 'GBP':
        return l10n.gbpName;
      case 'SAR':
        return l10n.sarName;
      default:
        return defaultName;
    }
  }

  String _getLocalizedCurrencySymbol(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context)!;
    switch (code.toUpperCase()) {
      case 'EGP':
        return l10n.egpSymbol;
      case 'USD':
        return l10n.usdSymbol;
      case 'EUR':
        return l10n.eurSymbol;
      case 'GBP':
        return l10n.gbpSymbol;
      case 'SAR':
        return l10n.sarSymbol;
      case 'JPY':
        return l10n.jpySymbol;
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    // isStrengthening = EGP got stronger (foreign rate went down)
    // true  → ▼ green (good for EGP)
    // false → ▲ red   (bad for EGP)
    final Color changeColor = rate.isStrengthening
        ? AppColors.greenStrengthening
        : AppColors.redWeakening;
    final String changeArrow = rate.isStrengthening ? '▼' : '▲';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: onTap,
          splashColor: AppColors.teal.withOpacity(0.1),
          highlightColor: AppColors.gold.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Hero(
                  tag: 'currency_flag_${rate.code}',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.cardSurfaceLight,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColors.cardBorderGlow,
                          width: 0.8,
                        ),
                      ),
                      child: Text(rate.flag, style: AppTextStyles.flagMedium),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'currency_code_${rate.code}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            _getLocalizedCurrencySymbol(context, rate.code),
                            style: AppTextStyles.currencyCode,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          _getLocalizedCurrencyName(
                              context, rate.code, rate.name),
                          style: AppTextStyles.currencyName,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 36.h,
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: SparklineWidget(
                      data: rate.sparklineData,
                      lineColor: changeColor,
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${CurrencyFormatter.formatRate(rate.rate, decimals: 2)} ${_getLocalizedCurrencySymbol(context, 'EGP')}',
                      style: AppTextStyles.rateSmall,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: changeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: changeColor.withOpacity(0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$changeArrow ${CurrencyFormatter.formatPercent(rate.percentageChange.abs())}',
                            style: AppTextStyles.badgeSmall.copyWith(
                              color: changeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
