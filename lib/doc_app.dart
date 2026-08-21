import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_axis/core/di/dependency_injection.dart';
import 'package:task_axis/core/routing/app_router.dart';
import 'package:task_axis/core/theme/app_text_styles.dart';
import 'package:task_axis/features/settings/presentation/bloc/locale_cubit.dart';
import 'package:task_axis/features/settings/presentation/bloc/locale_state.dart';
import 'package:task_axis/l10n/app_localizations.dart';
import 'core/routing/routes.dart';

class TaskAxisApp extends StatelessWidget {
  final AppRouter appRouter;
  const TaskAxisApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleCubit>(
      create: (context) => getIt<LocaleCubit>(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) => MaterialApp(
              title: 'Currency Axis',
              theme: AppTheme.darkTheme,
              locale: state.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              initialRoute: Routes.exchangeRatesList,
              onGenerateRoute: appRouter.generateRoute,
            ),
          );
        },
      ),
    );
  }
}

