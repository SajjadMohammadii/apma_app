// سرویس مدیریت دسترسی‌های برنامه
// مرتبط با: permission_mixin.dart, permission_dialog.dart

import 'package:permission_handler/permission_handler.dart'; // کتابخانه مدیریت دسترسی‌ها
import 'dart:developer' as developer; // ابزار لاگ‌گیری

// کلاس PermissionService - سرویس بررسی و درخواست دسترسی‌ها
class PermissionService {
  // لیست دسترسی‌های مورد نیاز برنامه
  static const List<Permission> requiredPermissions = [
    Permission.camera, // دسترسی دوربین
    Permission.microphone, // دسترسی میکروفون
    Permission.location, // دسترسی موقعیت مکانی
    Permission.contacts, // دسترسی مخاطبین
    Permission.photos, // دسترسی عکس‌ها
    Permission.storage, // دسترسی فضای ذخیره‌سازی
    Permission.notification, // دسترسی نوتیفیکیشن
  ];

  // متد استاتیک checkAllPermissions - بررسی تمام دسترسی‌ها
  // برمی‌گرداند: true اگر همه دسترسی‌ها داده شده باشند
  static Future<bool> checkAllPermissions() async {
    try {
      // بررسی هر دسترسی
      for (Permission permission in requiredPermissions) {
        final status = await permission.status; // دریافت وضعیت دسترسی
        if (!status.isGranted) {
          // اگر دسترسی داده نشده
          developer.log('❌ دسترسی رد شد: ${permission.toString()}');
          return false;
        }
      }
      developer.log('✅ تمام دسترسی ها موافق شدند');
      return true;
    } catch (e) {
      developer.log('⚠️ خطا در بررسی دسترسی‌ها: $e');
      return false;
    }
  }

  // متد استاتیک requestAllPermissions - درخواست تمام دسترسی‌ها
  // برمی‌گرداند: true اگر همه دسترسی‌ها موفقیت‌آمیز باشند
  static Future<bool> requestAllPermissions() async {
    try {
      bool allGranted = true; // متغیر پیگیری وضعیت کلی
      Map<Permission, PermissionStatus> statuses = {}; // نقشه وضعیت دسترسی‌ها

      // درخواست هر دسترسی
      for (Permission permission in requiredPermissions) {
        final status = await permission.request(); // درخواست دسترسی
        statuses[permission] = status; // ذخیره وضعیت

        if (!status.isGranted) {
          // اگر دسترسی رد شد
          allGranted = false;
          developer.log('❌ دسترسی رد شد: ${permission.toString()}');
        } else {
          developer.log('✅ دسترسی موافق شد: ${permission.toString()}');
        }
      }

      return allGranted; // برگرداندن نتیجه کلی
    } catch (e) {
      developer.log('⚠️ خطا در درخواست دسترسی‌ها: $e');
      return false;
    }
  }
}
