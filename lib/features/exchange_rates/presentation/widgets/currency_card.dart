import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_axis/features/exchange_rates/domain/entities/exchange_rate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import 'package:task_axis/l10n/app_localizations.dart';

class CurrencyCard extends StatelessWidget {
  final String label;
  final ExchangeRate currency;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onCurrencyTap;
  final ValueChanged<String> onAmountChanged;
  final bool isTopCard;

  const CurrencyCard({
    super.key,
    required this.label,
    required this.currency,
    required this.controller,
    this.focusNode,
    required this.onCurrencyTap,
    required this.onAmountChanged,
    this.isTopCard = true,
  });

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
      case 'JPY':
        return l10n.jpyName;
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.sectionLabelSmall.copyWith(
                  color: isTopCard ? AppColors.teal : AppColors.gold,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: (isTopCard ? AppColors.teal : AppColors.gold)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  isTopCard ? l10n.source : l10n.target,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: isTopCard ? AppColors.teal : AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onCurrencyTap,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currency.flag,
                          style: TextStyle(fontSize: 28.sp),
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getLocalizedCurrencySymbol(context, currency.code),
                                  style: AppTextStyles.currencyCode.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textSecondary,
                                  size: 22.sp,
                                ),
                              ],
                            ),

                            SizedBox(height: 2.h),
                            Text(
                              _getLocalizedCurrencyName(
                                  context, currency.code, currency.name),
                              style: AppTextStyles.currencyName.copyWith(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              SizedBox(width: 12.w),

              Expanded(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final textLength = value.text.length;
                    double dynamicFontSize = 26.sp;
                    if (textLength > 12) {
                      dynamicFontSize = 13.sp;
                    } else if (textLength > 10) {
                      dynamicFontSize = 15.sp;
                    } else if (textLength > 8) {
                      dynamicFontSize = 18.sp;
                    } else if (textLength > 6) {
                      dynamicFontSize = 21.sp;
                    }

                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      onChanged: onAmountChanged,
                      style: TextStyle(
                        fontSize: dynamicFontSize,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: TextStyle(
                          fontSize: dynamicFontSize,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
