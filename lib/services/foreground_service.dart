import 'dart:async'; // کتابخانه برای کار با عملیات غیرهمزمان
import 'dart:developer' as AppLogger show log; // لاگر برای دیباگ
import 'dart:io'; // کتابخانه برای کار با سیستم‌عامل
import 'package:flutter_foreground_task/flutter_foreground_task.dart'; // پکیج تسک پیش‌زمینه

// تابع startCallback - نقطه ورود برای شروع تسک در پس‌زمینه
@pragma('vm:entry-point') // دستور به کامپایلر برای حفظ این تابع
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler()); // تنظیم هندلر تسک
}

// کلاس MyTaskHandler - مدیریت‌کننده رویدادهای تسک پس‌زمینه
class MyTaskHandler extends TaskHandler {
  int _count = 0; // متغیر شمارنده برای تعداد دفعات اجرا

  @override
  // متد onStart - هنگام شروع سرویس پس‌زمینه اجرا می‌شود
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    AppLogger.log('✅ Background Service STARTED'); // لاگ شروع سرویس
    print(
      '✅ [APMA Background] Service Started at: $timestamp',
    ); // چاپ زمان شروع
    // سرویس شروع شد
  }

  @override
  // متد onRepeatEvent - در هر بازه زمانی تکرار می‌شود (هر ۵ ثانیه)
  Future<void> onRepeatEvent(DateTime timestamp) async {
    AppLogger.log(
      '🔄 Background running - Count: $_count',
    ); // لاگ اجرای پس‌زمینه
    print(
      '🔄 [APMA Background] Running... Count: $_count at $timestamp',
    ); // چاپ وضعیت
    _count++; // افزایش شمارنده

    // اینجا کارهایی که می‌خوای در بکگراند انجام بشه

    // آپدیت نوتیفیکیشن - به‌روزرسانی متن نوتیفیکیشن
    FlutterForegroundTask.updateService(
      notificationTitle: 'APMA App', // عنوان نوتیفیکیشن
      notificationText: 'فعال - $_count بار', // متن نوتیفیکیشن با شمارنده
    );
  }

  @override
  // متد onDestroy - هنگام توقف سرویس اجرا می‌شود
  Future<void> onDestroy(DateTime timestamp, bool isForced) async {
    AppLogger.log('🔄 Background running - Count: $_count'); // لاگ توقف
    print(
      '🔄 [APMA Background] Running... Count: $_count at $timestamp',
    ); // چاپ وضعیت
    // سرویس متوقف شد
  }

  @override
  // متد onNotificationButtonPressed - هنگام کلیک روی دکمه نوتیفیکیشن
  void onNotificationButtonPressed(String id) {
    // دکمه نوتیف کلیک شد
  }

  @override
  // متد onNotificationPressed - هنگام کلیک روی خود نوتیفیکیشن
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/'); // باز کردن برنامه در صفحه اصلی
  }

  @override
  // متد onNotificationDismissed - هنگام رد کردن نوتیفیکیشن
  void onNotificationDismissed() {
    // نوتیف dismiss شد
  }
}

// کلاس ForegroundService - مدیریت سرویس پیش‌زمینه
class ForegroundService {
  static bool _isRunning = false; // متغیر وضعیت اجرای سرویس

  // متد init - راه‌اندازی اولیه سرویس
  static Future<void> init() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500, // شناسه نوتیفیکیشن
        channelId: 'apma_service', // شناسه کانال نوتیفیکیشن
        channelName: 'APMA Background Service', // نام کانال
        channelDescription: 'اپلیکیشن APMA در حال اجراست', // توضیحات کانال
        channelImportance: NotificationChannelImportance.HIGH, // اهمیت بالا
        priority: NotificationPriority.HIGH, // اولویت بالا
        onlyAlertOnce: true, // فقط یک بار هشدار بده
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true, // نمایش نوتیفیکیشن در iOS
        playSound: false, // بدون صدا
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(
          5000,
        ), // تکرار هر ۵۰۰۰ میلی‌ثانیه
        autoRunOnBoot: true, // اجرای خودکار هنگام روشن شدن دستگاه
        autoRunOnMyPackageReplaced: true, // اجرای خودکار بعد از آپدیت اپ
        allowWakeLock: true, // اجازه بیدار نگه داشتن دستگاه
        allowWifiLock: true, // اجازه فعال نگه داشتن WiFi
      ),
    );
  }

  // متد start - شروع سرویس پیش‌زمینه
  static Future<bool> start() async {
    if (_isRunning) {
      // اگر سرویس در حال اجراست
      return true; // برگردان true
    }

    // درخواست دسترسی‌ها
    await _requestPermissions();

    // شروع سرویس
    await FlutterForegroundTask.startService(
      serviceId: 500, // شناسه سرویس
      notificationTitle: 'APMA App', // عنوان نوتیفیکیشن
      notificationText: 'در حال اجرا', // متن نوتیفیکیشن
      callback: startCallback, // تابع callback برای شروع
    );

    _isRunning = true; // تنظیم وضعیت به در حال اجرا
    return true;
  }

  // متد _requestPermissions - درخواست دسترسی‌های لازم
  static Future<void> _requestPermissions() async {
    // دسترسی نوتیفیکیشن
    if (Platform.isAndroid) {
      // اگر پلتفرم اندروید است
      final notificationPermission =
          await FlutterForegroundTask.checkNotificationPermission(); // بررسی دسترسی نوتیفیکیشن
      if (notificationPermission != NotificationPermission.granted) {
        // اگر دسترسی داده نشده
        await FlutterForegroundTask.requestNotificationPermission(); // درخواست دسترسی
      }

      // دسترسی Battery Optimization - بهینه‌سازی باتری
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // اگر بهینه‌سازی باتری فعال است
        await FlutterForegroundTask.requestIgnoreBatteryOptimization(); // درخواست نادیده گرفتن بهینه‌سازی
      }
    }
  }

  // متد stop - توقف سرویس پیش‌زمینه
  static Future<bool> stop() async {
    if (!_isRunning) {
      // اگر سرویس در حال اجرا نیست
      return true;
    }

    await FlutterForegroundTask.stopService(); // توقف سرویس
    _isRunning = false; // تنظیم وضعیت به متوقف
    return true;
  }

  // getter isRunning - دریافت وضعیت اجرای سرویس
  static bool get isRunning => _isRunning;
}
