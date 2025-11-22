import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceManagementPage extends StatefulWidget {
  const PriceManagementPage({super.key});

  @override
  State<PriceManagementPage> createState() => _PriceManagementPageState();
}

class _PriceManagementPageState extends State<PriceManagementPage> {
  String selectedStatus = 'در حال بررسی';
  Map<int, String> subFieldStatuses = {};
  final List<String> statusOptions = ['در حال بررسی', 'تایید شده', 'رد شده'];
  Set<int> expandedRows = {};
  bool hasChanges = false; // برای ردیابی تغییرات

  final List<Map<String, dynamic>> mainData = [
    {
      'id': 1,
      'date': '28/08/1404',
      'number': '24536',
      'customer': 'شرکت داروسازی کاسپین',
      'issuer': 'بهار دولتی',
    },
    {
      'id': 2,
      'date': '27/08/1404',
      'number': '24537',
      'customer': 'شرکت پخش البرز',
      'issuer': 'علی احمدی',
    },
    {
      'id': 3,
      'date': '26/08/1404',
      'number': '24538',
      'customer': 'شرکت داروپخش',
      'issuer': 'سارا رضایی',
    },
    {
      'id': 4,
      'date': '25/08/1404',
      'number': '24539',
      'customer': 'شرکت پخش رازی',
      'issuer': 'محمد کریمی',
    },
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // مقداردهی اولیه برای دراپ‌داون‌ها
    for (var item in mainData) {
      subFieldStatuses[item['id']] = 'در حال بررسی';
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.primaryGreen,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          title: Row(
            children: [
              _buildInfoField('از تاریخ: 1403/08/22'),
              const SizedBox(width: 16),
              _buildInfoField('تا تاریخ: 1403/08/22'),
              const Spacer(),
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    dropdownColor: Colors.white,
                    isDense: true,
                    alignment: Alignment.centerRight,
                    style: const TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 10,
                      color: Colors.black87,
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return statusOptions.map((String value) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontFamily: 'Vazir',
                              fontSize: 10,
                              color: Colors.black87,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        );
                      }).toList();
                    },
                    items:
                        statusOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            alignment: Alignment.centerRight,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: 'Vazir',
                                fontSize: 10,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedStatus = newValue;
                          hasChanges = true; // تغییر انجام شده
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // دکمه ذخیره تغییرات
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: hasChanges ? AppColors.primaryPurple : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        hasChanges = false; // بعد از ذخیره، تغییرات ریست می‌شود
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تغییرات ذخیره شد')),
                      );
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Center(
                      child: Text(
                        'ذخیره تغییرات',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: hasChanges ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // هدر جدول اصلی - ثابت
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            _buildHeader('ردیف', flex: 1),
                            _buildDivider(),
                            _buildHeader('تاریخ پیش فاکتور', flex: 2),
                            _buildDivider(),
                            _buildHeader('شماره پیش فاکتور', flex: 2),
                            _buildDivider(),
                            _buildHeader('مشتری', flex: 3),
                            _buildDivider(),
                            _buildHeader('صادرکننده', flex: 2),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.3),
                        margin: const EdgeInsets.only(top: 8),
                      ),
                    ],
                  ),
                ),
                // لیست ردیف‌های داده - قابل اسکرول
                Expanded(
                  child: Container(
                    color: Colors.white, // بکگراند سفید برای کل قسمت
                    child: ListView.builder(
                      itemCount: mainData.length,
                      itemBuilder: (context, index) {
                        final item = mainData[index];
                        final isExpanded = expandedRows.contains(item['id']);
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (isExpanded) {
                                    expandedRows.remove(item['id']);
                                  } else {
                                    expandedRows.add(item['id']);
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    color: AppColors.primaryPurple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  isExpanded
                                                      ? Icons.keyboard_arrow_up
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${item['id']}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontFamily: 'Vazir',
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          _buildDivider(),
                                          _buildCell(item['date'], flex: 2),
                                          _buildDivider(),
                                          _buildCell(item['number'], flex: 2),
                                          _buildDivider(),
                                          _buildCell(item['customer'], flex: 3),
                                          _buildDivider(),
                                          _buildCell(item['issuer'], flex: 2),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                            // جدول زیرمجموعه
                            if (isExpanded) ...[
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  children: [
                                    // هدر جدول زیرمجموعه
                                    Column(
                                      children: [
                                        Container(
                                          color: AppColors.primaryGreen,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                _buildSubHeader(
                                                  'تاریخ درخواست',
                                                  flex: 2,
                                                ),
                                                _buildDivider(),
                                                _buildSubHeader(
                                                  'عنوان کالا',
                                                  flex: 2,
                                                ),
                                                _buildDivider(),
                                                _buildSubHeader(
                                                  'نوع درخواست',
                                                  flex: 2,
                                                ),
                                                _buildDivider(),
                                                _buildSubHeader(
                                                  'مبلغ فعلی',
                                                  flex: 2,
                                                ),
                                                _buildDivider(),
                                                _buildSubHeader(
                                                  'مبلغ درخواست شده',
                                                  flex: 2,
                                                ),
                                                _buildDivider(),
                                                _buildSubHeader(
                                                  'وضعیت تایید',
                                                  flex: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                    // ردیف داده زیرمجموعه
                                    Column(
                                      children: [
                                        Container(
                                          color: const Color(0xFFE8E8E8),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                _buildSubCell(
                                                  '1403/08/28',
                                                  flex: 2,
                                                  dark: true,
                                                ),
                                                _buildDivider(dark: true),
                                                _buildSubCell(
                                                  'محصول الف',
                                                  flex: 2,
                                                  dark: true,
                                                ),
                                                _buildDivider(dark: true),
                                                _buildSubCell(
                                                  'افزایش قیمت',
                                                  flex: 2,
                                                  dark: true,
                                                ),
                                                _buildDivider(dark: true),
                                                _buildSubCell(
                                                  '150000',
                                                  flex: 2,
                                                  dark: true,
                                                ),
                                                _buildDivider(dark: true),
                                                _buildSubCell(
                                                  '180000',
                                                  flex: 2,
                                                  dark: true,
                                                ),
                                                _buildDivider(dark: true),
                                                _buildSubCellWithDropdown(
                                                  item['id'],
                                                  flex: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String text) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Vazir',
            fontSize: 10,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider({bool dark = false}) {
    return Container(
      width: 1,
      color:
          dark ? Colors.black.withOpacity(0.1) : Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildHeader(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Vazir',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Vazir',
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubHeader(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Vazir',
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubCell(String text, {required int flex, bool dark = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Vazir',
          fontSize: 11,
          color: dark ? Colors.black87 : Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubCellWithDropdown(int id, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Container(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.primaryGreen, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: subFieldStatuses[id],
              dropdownColor: Colors.white,
              isDense: true,
              alignment: Alignment.centerRight,
              style: const TextStyle(
                fontFamily: 'Vazir',
                fontSize: 9,
                color: Colors.black87,
              ),
              selectedItemBuilder: (BuildContext context) {
                return statusOptions.map((String value) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 9,
                        color: Colors.black87,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  );
                }).toList();
              },
              items:
                  statusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      alignment: Alignment.centerRight,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 9,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    subFieldStatuses[id] = newValue;
                    hasChanges = true; // تغییر انجام شده
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
