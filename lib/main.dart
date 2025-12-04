// نقطه ورود اصلی برنامه APMA
// مرتبط با: injection_container.dart, splash_screen.dart, auth_bloc.dart
import 'dart:io'; // کتابخانه برای کار با سیستم‌عامل و فایل‌ها

import 'package:apma_app/core/constants/app_string.dart'; // رشته‌های ثابت برنامه
import 'package:apma_app/core/themes/app_theme.dart'; // تم و استایل برنامه
import 'package:apma_app/screens/splash/splash_screen.dart'; // صفحه اسپلش (صفحه شروع)
import 'package:apma_app/services/foreground_service.dart'; // سرویس پس‌زمینه
import 'package:flutter/foundation.dart'; // ابزارهای پایه فلاتر
import 'package:flutter/material.dart'; // ویجت‌های متریال دیزاین
import 'package:flutter/services.dart'; // سرویس‌های سیستمی فلاتر
import 'package:flutter_bloc/flutter_bloc.dart'; // مدیریت state با BLoC
import 'package:flutter_foreground_task/flutter_foreground_task.dart'; // تسک‌های پیش‌زمینه

// DI - تزریق وابستگی
import 'core/di/injection_container.dart' as di; // کانتینر تزریق وابستگی
import 'features/auth/presentation/bloc/auth_bloc.dart'; // بلاک احراز هویت

/// تابع main - نقطه شروع برنامه، تنظیمات اولیه و تزریق وابستگی‌ها را انجام می‌دهد
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // اطمینان از آماده بودن binding ویجت‌ها

  // تنظیم جهت‌های مجاز صفحه (فقط عمودی)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // عمودی - بالا
    DeviceOrientation.portraitDown, // عمودی - پایین
  ]);

  // مقداردهی اولیه GetIt (سیستم تزریق وابستگی)
  await di.init();

  // اگر وب نیست و اندروید است، سرویس پس‌زمینه را شروع کن
  if (!kIsWeb && Platform.isAndroid) {
    await ForegroundService.init(); // مقداردهی سرویس پیش‌زمینه
    await ForegroundService.start(); // شروع سرویس پیش‌زمینه
  }

  runApp(const ApmacoApp()); // اجرای ویجت اصلی برنامه
}

// کلاس ApmacoApp - ویجت ریشه برنامه APMA با تنظیمات BLoC Provider
// مرتبط با: app_theme.dart, auth_bloc.dart, splash_screen.dart
class ApmacoApp extends StatelessWidget {
  const ApmacoApp({super.key}); // سازنده کلاس با کلید اختیاری

  @override
  Widget build(BuildContext context) {
    // متد build - ساخت درخت ویجت
    return BlocProvider<AuthBloc>(
      // فراهم‌کننده بلاک احراز هویت برای کل برنامه
      create:
          (context) =>
              di.sl<AuthBloc>(), // ساخت نمونه AuthBloc از service locator
      child: MaterialApp(
        // ویجت اصلی متریال اپ
        title: AppStrings.appName, // عنوان برنامه
        debugShowCheckedModeBanner: false, // مخفی کردن بنر debug
        theme: AppTheme.lightTheme, // تم روشن برنامه
        home: WithForegroundTask(
          child: const SplashScreen(),
        ), // صفحه خانه با پشتیبانی از تسک پیش‌زمینه
      ),
    );
  }
}
