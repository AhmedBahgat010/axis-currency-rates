import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_axis/features/exchange_rates/domain/entities/exchange_rate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../bloc/currency_converter/currency_converter_cubit.dart';
import '../bloc/currency_converter/currency_converter_state.dart';
import '../widgets/currency_card.dart';
import '../widgets/currency_picker_bottom_sheet.dart';
import '../widgets/error_retry_view.dart';
import '../widgets/offline_banner.dart';
import '../widgets/shimmer_loading.dart';

class CurrencyConverterScreen extends StatefulWidget {
  final ExchangeRate? initialFrom;
  final ExchangeRate? initialTo;

  const CurrencyConverterScreen({
    super.key,
    this.initialFrom,
    this.initialTo,
  });

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  late final FocusNode _fromFocusNode;
  late final FocusNode _toFocusNode;

  late final AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;

  double _turns = 0.0;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController();
    _toController = TextEditingController();
    _fromFocusNode = FocusNode();
    _toFocusNode = FocusNode();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutBack,
    );

    // Initial rates load
    context.read<CurrencyConverterCubit>().loadRates(
          initialFrom: widget.initialFrom,
          initialTo: widget.initialTo,
        );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _onSwapTapped() {
    setState(() {
      _turns += 0.5; // 180 degrees spin
    });
    context.read<CurrencyConverterCubit>().swapCurrencies();
  }

  void _syncControllers(CurrencyConverterState state) {
    // Synchronize From input if not currently typing in it
    if (!_fromFocusNode.hasFocus && _fromController.text != state.fromAmountText) {
      _fromController.text = state.fromAmountText;
    }
    // Synchronize To input if not currently typing in it
    if (!_toFocusNode.hasFocus && _toController.text != state.toAmountText) {
      _toController.text = state.toAmountText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.swap_calls_rounded,
                size: 18.sp,
                color: AppColors.background,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Currency Converter',
              style: AppTextStyles.appBarTitle,
            ),
          ],
        ),
      ),
      body: BlocConsumer<CurrencyConverterCubit, CurrencyConverterState>(
        listener: (context, state) {
          _syncControllers(state);
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const ShimmerListLoading();
          }

          if (state.errorMessage != null && state.availableRates.isEmpty) {
            return ErrorRetryView(
              message: state.errorMessage!,
              onRetry: () => context.read<CurrencyConverterCubit>().loadRates(),
            );
          }

          final fromRate = state.fromCurrency;
          final toRate = state.toCurrency;
          final exchangeRateVal = state.currentExchangeRate;

          // Format exchange rate string e.g. "1 EGP = 0.0206 USD"
          final exchangeRateText =
              '1 ${fromRate.code} = ${CurrencyFormatter.formatRate(exchangeRateVal, decimals: exchangeRateVal < 1 ? 4 : 2)} ${toRate.code}';

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Offline Banner if using cache
                  if (state.isOffline && state.lastUpdated != null)
                    OfflineBanner(lastUpdated: state.lastUpdated!),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Stacked Input Cards with Swap Button ─────────────
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                // Top Card: FROM Currency
                                CurrencyCard(
                                  label: 'From',
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

                                SizedBox(height: 16.h),

                                // Bottom Card: TO Currency
                                CurrencyCard(
                                  label: 'To',
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
                            ),

                            // Circular Swap Button Floating Between Cards
                            AnimatedRotation(
                              turns: _turns,
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOutBack,
                              child: Material(
                                elevation: 8,
                                shadowColor: AppColors.teal.withOpacity(0.4),
                                shape: const CircleBorder(),
                                color: Colors.transparent,
                                child: Container(
                                  width: 48.r,
                                  height: 48.r,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.background,
                                      width: 4.r,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: _onSwapTapped,
                                    customBorder: const CircleBorder(),
                                    child: Icon(
                                      Icons.swap_vert_rounded,
                                      color: AppColors.background,
                                      size: 26.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // ── Rate Information Banner ──────────────────────────
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: AppColors.cardSurfaceLight,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.cardBorder,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EXCHANGE RATE',
                                    style: AppTextStyles.sectionLabelSmall.copyWith(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    exchangeRateText,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              if (state.lastUpdated != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'LAST UPDATED',
                                      style: AppTextStyles.sectionLabelSmall.copyWith(
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      CurrencyFormatter.formatDateTime(
                                          state.lastUpdated!),
                                      style: AppTextStyles.timestampSmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
