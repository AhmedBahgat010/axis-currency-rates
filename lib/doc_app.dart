import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_axis/core/routing/app_router.dart';
import 'package:task_axis/core/theme/app_text_styles.dart';
import 'core/routing/routes.dart';

class TaskAxisApp extends StatelessWidget {
  final AppRouter appRouter;
  const TaskAxisApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'Currency Exchange Tracker',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.exchangeRatesList,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
