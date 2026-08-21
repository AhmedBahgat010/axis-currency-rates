import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_axis/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/locale_cubit.dart';
import '../bloc/locale_state.dart';

class SideDrawerWidget extends StatelessWidget {
  const SideDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              decoration: const BoxDecoration(
                color: AppColors.cardSurface,
                border: Border(
                  bottom: BorderSide(color: AppColors.cardBorder, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.currency_exchange_rounded,
                      size: 26.sp,
                      color: AppColors.background,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    l10n.appTitle,
                    style: AppTextStyles.screenTitle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    l10n.settings,
                    style: AppTextStyles.bodyPrimary.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Language Section Label
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                l10n.language.toUpperCase(),
                style: AppTextStyles.sectionLabelSmall.copyWith(
                  color: AppColors.teal,
                  letterSpacing: 1.4,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Language Options
            BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, state) {
                final currentCode = state.locale.languageCode;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      _LanguageTile(
                        title: l10n.english,
                        subtitle: 'English',
                        flag: '🇺🇸',
                        isSelected: currentCode == 'en',
                        onTap: () {
                          context.read<LocaleCubit>().changeLocale('en');
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 10.h),
                      _LanguageTile(
                        title: l10n.arabic,
                        subtitle: 'العربية',
                        flag: '🇪🇬',
                        isSelected: currentCode == 'ar',
                        onTap: () {
                          context.read<LocaleCubit>().changeLocale('ar');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.teal.withOpacity(0.12)
              : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? AppColors.teal : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: 24.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.currencyCode.copyWith(
                  fontSize: 16.sp,
                  color: isSelected ? AppColors.teal : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.teal,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
