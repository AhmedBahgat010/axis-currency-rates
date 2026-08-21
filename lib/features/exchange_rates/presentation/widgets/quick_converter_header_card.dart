import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../bloc/currency_converter/currency_converter_cubit.dart';
import '../bloc/currency_converter/currency_converter_state.dart';
import 'currency_card.dart';
import 'currency_picker_bottom_sheet.dart';

import 'package:task_axis/l10n/app_localizations.dart';


class QuickConverterHeaderCard extends StatefulWidget {
  const QuickConverterHeaderCard({super.key});

  @override
  State<QuickConverterHeaderCard> createState() =>
      _QuickConverterHeaderCardState();
}

class _QuickConverterHeaderCardState extends State<QuickConverterHeaderCard> {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  late final FocusNode _fromFocusNode;
  late final FocusNode _toFocusNode;

  double _turns = 0.0;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController();
    _toController = TextEditingController();
    _fromFocusNode = FocusNode();
    _toFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
    super.dispose();
  }

  void _onSwapTapped() {
    setState(() {
      _turns += 0.5;
    });
    context.read<CurrencyConverterCubit>().swapCurrencies();
  }

  void _syncControllers(CurrencyConverterState state) {
    if (!_fromFocusNode.hasFocus && _fromController.text != state.fromAmountText) {
      _fromController.text = state.fromAmountText;
    }
    if (!_toFocusNode.hasFocus && _toController.text != state.toAmountText) {
      _toController.text = state.toAmountText;
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

    return BlocConsumer<CurrencyConverterCubit, CurrencyConverterState>(
      listener: (context, state) {
        _syncControllers(state);
      },
      builder: (context, state) {
        if (state.isLoading && state.availableRates.isEmpty) {
          return const SizedBox.shrink();
        }

        final fromRate = state.fromCurrency;
        final toRate = state.toCurrency;
        final exchangeRateVal = state.currentExchangeRate;

        final fromSymbol = _getLocalizedCurrencySymbol(context, fromRate.code);
        final toSymbol = _getLocalizedCurrencySymbol(context, toRate.code);

        final exchangeRateText =
            '1 $fromSymbol = ${CurrencyFormatter.formatRate(exchangeRateVal, decimals: exchangeRateVal < 1 ? 4 : 2)} $toSymbol';


        return Container(
          margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.cardSurfaceLight.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.cardBorderGlow.withOpacity(0.5),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title for Quick Converter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.swap_calls_rounded,
                        color: AppColors.teal,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        l10n.quickConverter,
                        style: AppTextStyles.sectionLabelSmall.copyWith(
                          color: AppColors.teal,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      exchangeRateText,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              // Stacked Currency Cards with Floating Swap Button
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      // Top Card (FROM)
                      CurrencyCard(
                        label: l10n.from,
                        currency: fromRate,
                        controller: _fromController,
                        focusNode: _fromFocusNode,
                        isTopCard: true,
                        onCurrencyTap: () {
                          CurrencyPickerBottomSheet.show(
                            context: context,
                            currencies: state.availableRates,
                            selectedCurrency: fromRate,
                            onSelected: (selected) {
                              context
                                  .read<CurrencyConverterCubit>()
                                  .selectFromCurrency(selected);
                            },
                          );
                        },
                        onAmountChanged: (val) {
                          context
                              .read<CurrencyConverterCubit>()
                              .onFromAmountChanged(val);
                        },
                      ),

                      SizedBox(height: 12.h),

                      // Bottom Card (TO)
                      CurrencyCard(
                        label: l10n.to,
                        currency: toRate,
                        controller: _toController,
                        focusNode: _toFocusNode,
                        isTopCard: false,
                        onCurrencyTap: () {
                          CurrencyPickerBottomSheet.show(
                            context: context,
                            currencies: state.availableRates,
                            selectedCurrency: toRate,
                            onSelected: (selected) {
                              context
                                  .read<CurrencyConverterCubit>()
                                  .selectToCurrency(selected);
                            },
                          );
                        },
                        onAmountChanged: (val) {
                          context
                              .read<CurrencyConverterCubit>()
                              .onToAmountChanged(val);
                        },
                      ),
                    ],
                  // Floating Swap Button

                  ),AnimatedRotation(
                    turns: _turns,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutBack,
                    child: Material(
                      elevation: 6,
                      shadowColor: AppColors.teal.withOpacity(0.4),
                      shape: const CircleBorder(),
                      color: Colors.transparent,
                      child: Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background,
                            width: 3.5.r,
                          ),
                        ),
                        child: InkWell(
                          onTap: _onSwapTapped,
                          customBorder: const CircleBorder(),
                          child: Icon(
                            Icons.swap_vert_rounded,
                            color: AppColors.background,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
