import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/exchange_rate.dart';

class CurrencyPickerBottomSheet extends StatefulWidget {
  final List<ExchangeRate> currencies;
  final ExchangeRate selectedCurrency;
  final ValueChanged<ExchangeRate> onSelected;

  const CurrencyPickerBottomSheet({
    super.key,
    required this.currencies,
    required this.selectedCurrency,
    required this.onSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required List<ExchangeRate> currencies,
    required ExchangeRate selectedCurrency,
    required ValueChanged<ExchangeRate> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CurrencyPickerBottomSheet(
        currencies: currencies,
        selectedCurrency: selectedCurrency,
        onSelected: onSelected,
      ),
    );
  }

  @override
  State<CurrencyPickerBottomSheet> createState() =>
      _CurrencyPickerBottomSheetState();
}

class _CurrencyPickerBottomSheetState extends State<CurrencyPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  static const Set<String> _designCurrencies = {
    'EGP',
    'USD',
    'EUR',
    'SAR',
    'JPY',
    'GBP',
  };

  List<ExchangeRate> get _allowedBaseCurrencies {
    return widget.currencies.where((c) {
      return _designCurrencies.contains(c.code.toUpperCase());
    }).toList();
  }

  List<ExchangeRate> _filteredCurrencies = [];
  @override
  void initState() {
    super.initState();
    _filteredCurrencies = _allowedBaseCurrencies;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    final baseList = _allowedBaseCurrencies;
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = baseList;
      } else {
        _filteredCurrencies = baseList.where((c) {
          final codeMatch = c.code.toLowerCase().contains(query);
          final nameMatch = c.name.toLowerCase().contains(query);
          return codeMatch || nameMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: 0.75.sh + bottomInset,
      ),
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),

          // Drag handle
          Center(
            child: Container(
              width: 44.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.cardBorderGlow,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Currency',
                  style: AppTextStyles.appBarTitle.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'Search currency code or name...',
                  hintStyle: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textMuted,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          color: AppColors.textMuted,
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          const Divider(height: 1),

          // Currency List
          Expanded(
            child: _filteredCurrencies.isEmpty
                ? Center(
                    child: Text(
                      'No currencies found',
                      style: AppTextStyles.bodyPrimary,
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    itemCount: _filteredCurrencies.length,
                    separatorBuilder: (_, __) => SizedBox(height: 6.h),
                    itemBuilder: (context, index) {
                      final item = _filteredCurrencies[index];
                      final isSelected =
                          item.code == widget.selectedCurrency.code;

                      return InkWell(
                        onTap: () {
                          widget.onSelected(item);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(14.r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.teal.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14.r),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.teal.withOpacity(0.5),
                                    width: 1.2,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Text(
                                item.flag,
                                style: TextStyle(fontSize: 26.sp),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.code,
                                      style:
                                          AppTextStyles.currencyCode.copyWith(
                                        color: isSelected
                                            ? AppColors.teal
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      item.name,
                                      style:
                                          AppTextStyles.currencyName.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: const BoxDecoration(
                                    color: AppColors.teal,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 14.sp,
                                    color: AppColors.background,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
