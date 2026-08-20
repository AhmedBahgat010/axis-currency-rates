import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_axis/core/helpers/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/exchange_rate.dart';
import '../bloc/currency_detail/currency_detail_bloc.dart';
import '../bloc/currency_detail/currency_detail_event.dart';
import '../bloc/currency_detail/currency_detail_state.dart';
import '../widgets/error_retry_view.dart';
import '../widgets/shimmer_loading.dart';

class CurrencyDetailScreen extends StatefulWidget {
  final ExchangeRate exchangeRate;

  const CurrencyDetailScreen({super.key, required this.exchangeRate});

  @override
  State<CurrencyDetailScreen> createState() => _CurrencyDetailScreenState();
}

class _CurrencyDetailScreenState extends State<CurrencyDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CurrencyDetailBloc>().add(
      FetchCurrencyHistoryEvent(widget.exchangeRate.code),
    );
  }

  @override
  Widget build(BuildContext context) {
    // isStrengthening = EGP got stronger (foreign rate went down)
    // true  → ▼ green (good for EGP)
    // false → ▲ red   (bad for EGP)
    final rate = widget.exchangeRate;
    final changeColor = rate.isStrengthening
        ? AppColors.greenStrengthening
        : AppColors.redWeakening;
    final changeArrow = rate.isStrengthening ? '▼' : '▲';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('${rate.code} / EGP', style: AppTextStyles.appBarTitle),
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Currency Header Card with Hero Transitions
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColors.cardBorder, width: 1.2),
                gradient: AppColors.cardGlowGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'currency_flag_${rate.code}',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: 56.w,
                            height: 56.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.cardSurfaceLight,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.cardBorderGlow,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              rate.flag,
                              style: AppTextStyles.flagLarge,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'currency_code_${rate.code}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                rate.code,
                                style: AppTextStyles.screenTitle,
                              ),
                            ),
                          ),
                          Text(rate.name, style: AppTextStyles.currencyName),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        CurrencyFormatter.formatRate(rate.rate, decimals: 4),
                        style: AppTextStyles.rateLarge,
                      ),
                      SizedBox(width: 8.w),
                      Text('EGP', style: AppTextStyles.currencyUnit),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: changeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: changeColor.withOpacity(0.35),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '$changeArrow ${CurrencyFormatter.formatDelta(rate.change, decimals: 4)} (${CurrencyFormatter.formatPercent(rate.percentageChange.abs())})',
                          style: AppTextStyles.badgeLarge.copyWith(
                            color: changeColor,
                          ),
                        ),
                      ),
                      Text(
                        'Last updated ${CurrencyFormatter.formatDateTime(rate.lastUpdated)}',
                        style: AppTextStyles.timestampSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),

            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('7-DAY PRICE ACTION', style: AppTextStyles.sectionLabel),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurfaceLight,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text('Interactive Chart', style: AppTextStyles.pill),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Interactive Line Chart with isolated error handling & shimmer
            BlocBuilder<CurrencyDetailBloc, CurrencyDetailState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return const ShimmerChartLoading();
                } else if (state is HistoryError) {
                  return Container(
                    height: 260.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1.2,
                      ),
                    ),
                    child: ErrorRetryView(
                      message: state.message,
                      onRetry: () => context.read<CurrencyDetailBloc>().add(
                        FetchCurrencyHistoryEvent(rate.code),
                      ),
                    ),
                  );
                } else if (state is HistoryLoaded) {
                  final history = state.historicalRates;
                  if (history.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final double minY =
                      history.reduce((a, b) => a < b ? a : b) * 0.995;
                  final double maxY =
                      history.reduce((a, b) => a > b ? a : b) * 1.005;

                  return Container(
                    height: 280.h,
                    padding: EdgeInsets.only(
                      top: 24.h,
                      bottom: 12.h,
                      left: 8.w,
                      right: 18.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: LineChart(
                      LineChartData(
                        minY: minY,
                        maxY: maxY,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: (maxY - minY) / 4,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: AppColors.cardBorder.withOpacity(0.6),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 24.h,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final int idx = value.toInt();
                                final now = DateTime.now();
                                final date = now.subtract(
                                  Duration(days: (history.length - 1) - idx),
                                );
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text(
                                    '${date.day}/${date.month}',
                                    style: AppTextStyles.chartAxis,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45.w,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toStringAsFixed(1),
                                  style: AppTextStyles.chartAxis,
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  '${spot.y.toStringAsFixed(4)} EGP',
                                  AppTextStyles.chartTooltip,
                                );
                              }).toList();
                            },
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: history.asMap().entries.map((e) {
                              return FlSpot(e.key.toDouble(), e.value);
                            }).toList(),
                            isCurved: true,
                            curveSmoothness: 0.35,
                            color: AppColors.teal,
                            barWidth: 3.2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 3.5,
                                  color: AppColors.background,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.teal,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.teal.withOpacity(0.35),
                                  AppColors.teal.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
