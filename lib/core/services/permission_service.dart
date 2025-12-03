import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;

class PermissionService {
  static const List<Permission> requiredPermissions = [
    Permission.camera,
    Permission.microphone,
    Permission.location,
    Permission.contacts,
    Permission.photos,
    Permission.storage,
    Permission.notification,
  ];

  static Future<bool> checkAllPermissions() async {
    try {
      for (Permission permission in requiredPermissions) {
        final status = await permission.status;
        if (!status.isGranted) {
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

  static Future<bool> requestAllPermissions() async {
    try {
      bool allGranted = true;
      Map<Permission, PermissionStatus> statuses = {};

      for (Permission permission in requiredPermissions) {
        final status = await permission.request();
        statuses[permission] = status;

        if (!status.isGranted) {
          allGranted = false;
          developer.log('❌ دسترسی رد شد: ${permission.toString()}');
        } else {
          developer.log('✅ دسترسی موافق شد: ${permission.toString()}');
        }
      }

      return allGranted;
    } catch (e) {
      developer.log('⚠️ خطا در درخواست دسترسی‌ها: $e');
      return false;
    }
  }
}
