import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_axis/core/di/dependency_injection.dart';
import 'package:task_axis/core/routing/app_router.dart';
import 'package:task_axis/doc_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  await ScreenUtil.ensureScreenSize();
  runApp(TaskAxisApp(appRouter: AppRouter()));
}
