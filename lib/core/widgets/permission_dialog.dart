import 'package:apma_app/core/constants/app_colors.dart';
import 'package:apma_app/core/services/permission_service.dart';
import 'package:apma_app/core/widgets/apmaco_logo.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;

class PermissionDialog extends StatefulWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionDialog({required this.onPermissionsGranted, super.key});

  @override
  State<PermissionDialog> createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<PermissionDialog>
    with SingleTickerProviderStateMixin {
  bool _isRequesting = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    setState(() => _isRequesting = true);

    final allGranted = await PermissionService.requestAllPermissions();

    setState(() => _isRequesting = false);

    if (allGranted) {
      developer.log('✅ تمام دسترسی‌ها موافقت کردند');
      widget.onPermissionsGranted();
      if (mounted) Navigator.pop(context);
    } else {
      developer.log('⚠️ برخی دسترسی‌ها رد شدند');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('لطفاً تمام دسترسی‌های لازم را اعطا کنید'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 16,
          backgroundColor: Colors.white,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // هدر با گرادیانت
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryOrange,
                          AppColors.primaryOrange.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        // لوگو
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const ApmacoLogo(width: 120, height: 40),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'دسترسی‌های مورد نیاز',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Vazir',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // محتوا
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'برای استفاده بهتر از برنامه، لطفاً دسترسی‌های زیر را اعطا کنید:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontFamily: 'Vazir',
                          ),
                        ),

                        const SizedBox(height: 20),

                        // لیست دسترسی‌ها
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              _permissionTile(
                                Icons.camera_alt_rounded,
                                'دوربین',
                                'برای اسکن بارکد و تصویربرداری',
                                Colors.blue,
                              ),
                              _divider(),
                              _permissionTile(
                                Icons.mic_rounded,
                                'میکروفن',
                                'برای ضبط صدا و تماس',
                                Colors.red,
                              ),
                              _divider(),
                              _permissionTile(
                                Icons.location_on_rounded,
                                'موقعیت مکانی',
                                'برای ردیابی و نقشه',
                                Colors.green,
                              ),
                              _divider(),
                              _permissionTile(
                                Icons.contacts_rounded,
                                'مخاطبین',
                                'برای دسترسی به لیست مخاطبین',
                                Colors.purple,
                              ),
                              _divider(),
                              _permissionTile(
                                Icons.photo_library_rounded,
                                'گالری',
                                'برای انتخاب و ذخیره تصاویر',
                                Colors.orange,
                              ),
                              _divider(),
                              _permissionTile(
                                Icons.folder_rounded,
                                'فایل‌ها',
                                'برای ذخیره و خواندن فایل‌ها',
                                Colors.teal,
                              ),
                              _divider(),
                              _permissionTile(
                                Icons.notifications_rounded,
                                'اعلان‌ها',
                                'برای دریافت اطلاع‌رسانی‌ها',
                                Colors.amber,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // دکمه اعطای دسترسی
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                _isRequesting ? null : _requestPermissions,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrange,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: AppColors.primaryOrange.withOpacity(
                                0.4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child:
                                _isRequesting
                                    ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 22,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'اعطای دسترسی‌ها',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Vazir',
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // دکمه تنظیمات
                        TextButton.icon(
                          onPressed: () => openAppSettings(),
                          icon: Icon(
                            Icons.settings_rounded,
                            color: AppColors.primaryGray,
                            size: 20,
                          ),
                          label: Text(
                            'باز کردن تنظیمات دستگاه',
                            style: TextStyle(
                              color: AppColors.primaryGray,
                              fontSize: 13,
                              fontFamily: 'Vazir',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _permissionTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'Vazir',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                    fontFamily: 'Vazir',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 16,
      endIndent: 16,
    );
  }
}
