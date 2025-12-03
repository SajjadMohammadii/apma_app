import 'dart:async';
import 'dart:developer' as AppLogger show log;
import 'dart:io';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  int _count = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    AppLogger.log('✅ Background Service STARTED');
    print('✅ [APMA Background] Service Started at: $timestamp');
    // سرویس شروع شد
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    AppLogger.log('🔄 Background running - Count: $_count');
    print('🔄 [APMA Background] Running... Count: $_count at $timestamp');
    _count++;

    // اینجا کارهایی که می‌خوای در بکگراند انجام بشه

    // آپدیت نوتیفیکیشن
    FlutterForegroundTask.updateService(
      notificationTitle: 'APMA App',
      notificationText: 'فعال - $_count بار',
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isForced) async {
    AppLogger.log('🔄 Background running - Count: $_count');
    print('🔄 [APMA Background] Running... Count: $_count at $timestamp');
    // سرویس متوقف شد
  }

  @override
  void onNotificationButtonPressed(String id) {
    // دکمه نوتیف کلیک شد
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
  }

  @override
  void onNotificationDismissed() {
    // نوتیف dismiss شد
  }
}

class ForegroundService {
  static bool _isRunning = false;

  // راه‌اندازی اولیه
  static Future<void> init() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500,
        channelId: 'apma_service',
        channelName: 'APMA Background Service',
        channelDescription: 'اپلیکیشن APMA در حال اجراست',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  // شروع سرویس
  static Future<bool> start() async {
    if (_isRunning) {
      return true;
    }

    // درخواست دسترسی‌ها
    await _requestPermissions();

    // شروع سرویس
    await FlutterForegroundTask.startService(
      serviceId: 500,
      notificationTitle: 'APMA App',
      notificationText: 'در حال اجرا',
      callback: startCallback,
    );

    _isRunning = true;
    return true;
  }

  // درخواست دسترسی‌ها
  static Future<void> _requestPermissions() async {
    // دسترسی نوتیفیکیشن
    if (Platform.isAndroid) {
      final notificationPermission =
          await FlutterForegroundTask.checkNotificationPermission();
      if (notificationPermission != NotificationPermission.granted) {
        await FlutterForegroundTask.requestNotificationPermission();
      }

      // دسترسی Battery Optimization
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
    }
  }

  // توقف سرویس
  static Future<bool> stop() async {
    if (!_isRunning) {
      return true;
    }

    await FlutterForegroundTask.stopService();
    _isRunning = false;
    return true;
  }

  // وضعیت
  static bool get isRunning => _isRunning;
}
