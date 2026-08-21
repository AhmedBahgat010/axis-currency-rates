import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';

import 'package:task_axis/l10n/app_localizations.dart';

class OfflineBanner extends StatelessWidget {
  final DateTime lastUpdated;

  const OfflineBanner({super.key, required this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.amberOfflineDark.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: AppColors.amberOffline.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 16.sp,
            color: AppColors.amberOffline,
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.showingCachedRatesFrom(
                  CurrencyFormatter.formatDateTime(lastUpdated),
                ),
                style: AppTextStyles.timestamp.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
