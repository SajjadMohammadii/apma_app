// صفحه ورود و خروج - ثبت ساعت ورود و خروج کارمندان
// مرتبط با: transaction.dart

import 'package:apma_app/core/constants/app_colors.dart'; // رنگ‌های برنامه
import 'package:flutter/material.dart'; // ویجت‌های متریال
import 'dart:async'; // کتابخانه async برای Timer

// کلاس EntryExitPage - صفحه ورود و خروج
class EntryExitPage extends StatefulWidget {
  const EntryExitPage({super.key});

  @override
  State<EntryExitPage> createState() => _EntryExitPageState();
}

// کلاس _EntryExitPageState - state صفحه ورود و خروج
class _EntryExitPageState extends State<EntryExitPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // کنترلر انیمیشن
  late Animation<double> _pulseAnimation; // انیمیشن پالس

  bool _isCheckedIn = false; // وضعیت حضور (ورود شده یا خیر)
  String _currentTime = ''; // زمان فعلی
  String _currentDate = ''; // تاریخ فعلی

  // داده‌های نمونه - سوابق امروز
  final List<Map<String, dynamic>> _todayRecords = [
    {'type': 'entry', 'time': '08:30', 'status': 'تایید شده'},
    {'type': 'exit', 'time': '12:00', 'status': 'تایید شده'},
    {'type': 'entry', 'time': '13:00', 'status': 'تایید شده'},
  ];

  // داده‌های نمونه - آمار هفتگی
  final List<Map<String, dynamic>> _weeklyStats = [
    {'day': 'شنبه', 'hours': '8:30', 'status': 'کامل'},
    {'day': 'یکشنبه', 'hours': '7:45', 'status': 'کسری'},
    {'day': 'دوشنبه', 'hours': '9:00', 'status': 'اضافه‌کار'},
    {'day': 'سه‌شنبه', 'hours': '8:00', 'status': 'کامل'},
    {'day': 'چهارشنبه', 'hours': '7:00', 'status': 'کامل'},
    {'day': 'پنج شنبه', 'hours': '-', 'status': 'امروز'},
  ];

  Timer? _timer; // تایمر به‌روزرسانی زمان

  @override
  // متد initState - مقداردهی اولیه انیمیشن و تایمر
  void initState() {
    super.initState();
    _updateTime(); // شروع به‌روزرسانی زمان
    // تنظیم انیمیشن پالس
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  // متد _updateTime - به‌روزرسانی زمان و تاریخ هر ثانیه
  void _updateTime() {
    if (!mounted) return;

    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _currentDate =
          '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';
    });

    _timer = Timer(const Duration(seconds: 1), _updateTime); // تایمر بازگشتی
  }

  @override
  // متد dispose - آزادسازی منابع
  void dispose() {
    _timer?.cancel(); // لغو تایمر
    _animationController.dispose(); // آزادسازی کنترلر انیمیشن
    super.dispose();
  }

  // متد _toggleCheckIn - تغییر وضعیت ورود/خروج
  void _toggleCheckIn() {
    setState(() {
      _isCheckedIn = !_isCheckedIn;
      // افزودن رکورد جدید
      _todayRecords.add({
        'type': _isCheckedIn ? 'entry' : 'exit',
        'time': _currentTime,
        'status': 'در انتظار',
      });
    });

    // نمایش پیام موفقیت
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCheckedIn ? 'ورود ثبت شد' : 'خروج ثبت شد',
          style: const TextStyle(fontFamily: 'Vazir'),
        ),
        backgroundColor: _isCheckedIn ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  // متد build - ساخت رابط کاربری صفحه
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // راست به چپ
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'ورود و خروج',
            style: TextStyle(fontFamily: 'Vazir', color: Colors.white),
          ),
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTimeCard(),
              const SizedBox(height: 20),
              _buildCheckInButton(),
              const SizedBox(height: 20),
              _buildTodayRecords(),
              const SizedBox(height: 20),
              _buildWeeklyStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple,
            AppColors.primaryPurple.withOpacity(0.7),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _currentTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazir',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentDate,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
              fontFamily: 'Vazir',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isCheckedIn ? Icons.login : Icons.logout,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _isCheckedIn ? 'وضعیت: حاضر' : 'وضعیت: خارج',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

  Widget _buildCheckInButton() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: GestureDetector(
        onTap: _toggleCheckIn,
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors:
                  _isCheckedIn
                      ? [Colors.orange, Colors.deepOrange]
                      : [AppColors.primaryGreen, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: (_isCheckedIn ? Colors.orange : AppColors.primaryGreen)
                    .withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isCheckedIn ? Icons.logout : Icons.fingerprint,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 8),
              Text(
                _isCheckedIn ? 'ثبت خروج' : 'ثبت ورود',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazir',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayRecords() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.today,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'رکوردهای امروز',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazir',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._todayRecords.map((record) => _buildRecordItem(record)).toList(),
        ],
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> record) {
    final isEntry = record['type'] == 'entry';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isEntry ? Colors.green : Colors.orange).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (isEntry ? Colors.green : Colors.orange).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isEntry ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEntry ? Icons.login : Icons.logout,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEntry ? 'ورود' : 'خروج',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Vazir',
                  ),
                ),
                Text(
                  'ساعت ${record['time']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontFamily: 'Vazir',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  record['status'] == 'تایید شده'
                      ? Colors.green.withOpacity(0.2)
                      : Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              record['status'],
              style: TextStyle(
                color:
                    record['status'] == 'تایید شده'
                        ? Colors.green[700]
                        : Colors.amber[700],
                fontSize: 11,
                fontFamily: 'Vazir',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStats() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.bar_chart,
                  color: AppColors.primaryPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'آمار هفتگی',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazir',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._weeklyStats.map((stat) => _buildStatItem(stat)).toList(),
        ],
      ),
    );
  }

  Widget _buildStatItem(Map<String, dynamic> stat) {
    Color statusColor;
    switch (stat['status']) {
      case 'کامل':
        statusColor = Colors.green;
        break;
      case 'کسری':
        statusColor = Colors.red;
        break;
      case 'اضافه‌کار':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              stat['day'],
              style: const TextStyle(
                fontFamily: 'Vazir',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value:
                  stat['hours'] == '-'
                      ? 0
                      : double.tryParse(stat['hours'].split(':')[0]) ?? 0 / 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            child: Text(
              stat['hours'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Vazir',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              stat['status'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontFamily: 'Vazir',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
