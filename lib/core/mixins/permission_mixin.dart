import 'dart:io';
import 'package:apma_app/core/services/permission_service.dart';
import 'package:apma_app/core/widgets/permission_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

mixin PermissionMixin<T extends StatefulWidget> on State<T> {
  bool _permissionsGranted = false;

  /// بررسی آیا پلتفرم موبایل است
  bool get _isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    // فقط در موبایل چک دسترسی انجام شود
    if (!_isMobile) {
      developer.log('🖥️ پلتفرم دسکتاپ/وب - نیازی به چک دسترسی نیست');
      setState(() => _permissionsGranted = true);
      return;
    }

    developer.log('🔍 بررسی دسترسی‌ها شروع شد');

    final hasPermissions = await PermissionService.checkAllPermissions();

    if (!hasPermissions) {
      developer.log('⚠️ دسترسی‌های ناقص - نمایش dialog');
      _showPermissionDialog();
    } else {
      setState(() => _permissionsGranted = true);
      developer.log('✅ تمام دسترسی‌ها موجود است');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => PermissionDialog(
            onPermissionsGranted: () {
              setState(() => _permissionsGranted = true);
              developer.log('✅ دسترسی‌ها اعطا شدند');
            },
          ),
    );
  }

  bool get hasPermissions => _permissionsGranted;

  void retryPermissions() {
    _checkAndRequestPermissions();
  }
}
