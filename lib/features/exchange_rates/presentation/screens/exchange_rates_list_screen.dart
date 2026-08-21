import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_axis/core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/exchange_rate.dart';
import '../bloc/currency_converter/currency_converter_cubit.dart';
import '../bloc/rates_list/rates_list_bloc.dart';
import '../bloc/rates_list/rates_list_event.dart';
import '../bloc/rates_list/rates_list_state.dart';
import '../widgets/error_retry_view.dart';
import '../widgets/offline_banner.dart';
import '../widgets/quick_converter_header_card.dart';
import '../widgets/rate_card.dart';
import '../widgets/shimmer_loading.dart';

import 'package:task_axis/l10n/app_localizations.dart';

import '../../../settings/presentation/widgets/side_drawer_widget.dart';

class ExchangeRatesListScreen extends StatefulWidget {
  const ExchangeRatesListScreen({super.key});

  @override
  State<ExchangeRatesListScreen> createState() =>
      _ExchangeRatesListScreenState();
}

class _ExchangeRatesListScreenState extends State<ExchangeRatesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RatesListBloc>().add(const FetchRatesEvent());
    context.read<CurrencyConverterCubit>().loadRates();
  }

  Future<void> _onRefresh() async {
    context.read<RatesListBloc>().add(const FetchRatesEvent(isRefresh: true));
    context.read<CurrencyConverterCubit>().loadRates();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawerWidget(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            color: AppColors.textPrimary,
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.currency_exchange_rounded,
                size: 20.sp,
                color: AppColors.background,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appTitle,
                  style: AppTextStyles.appBarTitle,
                ),
                Text(
                  l10n.baseCurrencySubtitle,
                  style: AppTextStyles.appBarSubtitle,
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocBuilder<RatesListBloc, RatesListState>(
        builder: (context, state) {
          if (state is RatesListLoading) {
            return const ShimmerListLoading();
          } else if (state is RatesListError) {
            return ErrorRetryView(
              message: state.message,
              onRetry: () =>
                  context.read<RatesListBloc>().add(const FetchRatesEvent()),
            );
          } else if (state is RatesListLoaded ||
              state is RatesListLoadedFromCache) {
            final List<ExchangeRate> rates = state is RatesListLoaded
                ? state.rates
                : (state as RatesListLoadedFromCache).rates;
            final DateTime lastUpdated = state is RatesListLoaded
                ? state.lastUpdated
                : (state as RatesListLoadedFromCache).lastUpdated;
            final bool isOffline = state is RatesListLoadedFromCache;

            return RefreshIndicator(
              color: AppColors.teal,
              backgroundColor: AppColors.cardSurface,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // Offline Banner
                  if (isOffline)
                    SliverToBoxAdapter(
                      child: OfflineBanner(lastUpdated: lastUpdated),
                    ),

                  // ── TOP CONVERTER CARD AT THE HEAD OF THE MAIN SCREEN ──
                  const SliverToBoxAdapter(
                    child: QuickConverterHeaderCard(),
                  ),

                  // Market Rates Section Title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.marketRates,
                            style: AppTextStyles.sectionLabelSmall,
                          ),
                          Text(
                            l10n.updatedAt(
                              CurrencyFormatter.formatDateTime(lastUpdated),
                            ),
                            style: AppTextStyles.timestampSmall,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final rateItem = rates[index];
                        return RateCard(
                          rate: rateItem,
                          onTap: () {
                            context.pushNamed(
                              Routes.currencyDetail,
                              arguments: rateItem,
                            );
                          },
                        );
                      },
                      childCount: rates.length,
                    ),
                  ),

                  SliverPadding(padding: EdgeInsets.only(bottom: 24.h)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
