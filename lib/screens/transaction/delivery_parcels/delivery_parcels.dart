import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'delivery_nearby_page.dart';

class DeliveryParcelsPage extends StatefulWidget {
  const DeliveryParcelsPage({super.key});

  @override
  State<DeliveryParcelsPage> createState() => _DeliveryParcelsPageState();
}

class _DeliveryParcelsPageState extends State<DeliveryParcelsPage> {
  final TextEditingController _searchController = TextEditingController();

  // داده‌های جدول
  final List<Map<String, dynamic>> _deliveryData = [];

  // مکان انتخاب شده
  String? _selectedLocation;
  String? _selectedSubLocation;

  // ساختار مکان‌ها
  final Map<String, List<String>> _locations = {
    'انبار تهران': ['انبار شماره ۱', 'انبار شماره ۲'],
    'محل مشتری': ['دفتر مرکزی', 'کارخانه'],
    'محل باربری': ['وطن', 'شمال', 'تیپاکس'],
  };

  bool get _isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  void initState() {
    super.initState();
    if (_isMobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    if (_isMobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // باکس سرچ در وسط
                Center(child: _buildSearchBox()),
                const SizedBox(height: 12),
                // جدول
                Container(height: screenHeight * 0.5, child: _buildTable()),
                const SizedBox(height: 12),
                // مکان تسهیل دار
                _buildLocationSelector(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontFamily: 'Vazir', fontSize: 13),
        decoration: InputDecoration(
          hintText: 'جستجوی مشتری...',
          hintStyle: TextStyle(
            fontFamily: 'Vazir',
            color: Colors.grey[400],
            fontSize: 13,
          ),
          suffixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // هدر جدول
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _buildHeaderCell('ردیف', flex: 1),
                _buildHeaderCell('شماره', flex: 2),
                _buildHeaderCell('مقصد', flex: 3),
                _buildHeaderCell('تاریخ', flex: 2),
                _buildHeaderCell('مشتری ها', flex: 3),
              ],
            ),
          ),

          // محتوای جدول
          Expanded(
            child:
                _deliveryData.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'داده‌ای برای نمایش وجود ندارد',
                            style: TextStyle(
                              fontFamily: 'Vazir',
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: _deliveryData.length,
                      itemBuilder: (context, index) {
                        final item = _deliveryData[index];
                        return _buildTableRow(index, item);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Vazir',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTableRow(int index, Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.grey[50] : Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          _buildCell('${index + 1}', flex: 1),
          _buildCell(item['number'] ?? '', flex: 2),
          _buildCell(item['destination'] ?? '', flex: 3),
          _buildCell(item['date'] ?? '', flex: 2),
          _buildCell(item['customers'] ?? '', flex: 3),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontFamily: 'Vazir', fontSize: 12),
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: AppColors.primaryGreen, size: 18),
          const SizedBox(width: 6),
          Text(
            'مکان:',
            style: TextStyle(
              fontFamily: 'Vazir',
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          // انتخاب مکان اصلی
          Expanded(
            flex: 2,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLocation,
                  isExpanded: true,
                  isDense: true,
                  alignment: AlignmentDirectional.centerEnd,
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                  hint: Text(
                    'مکان',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Vazir',
                    color: Colors.black87,
                    fontSize: 11,
                  ),
                  items:
                      _locations.keys.map((location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(location, textAlign: TextAlign.right),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value;
                      _selectedSubLocation = null;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // انتخاب زیرمجموعه
          Expanded(
            flex: 2,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSubLocation,
                  isExpanded: true,
                  isDense: true,
                  alignment: AlignmentDirectional.centerEnd,
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                  hint: Text(
                    'زیرمجموعه',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Vazir',
                    color: Colors.black87,
                    fontSize: 11,
                  ),
                  items:
                      _selectedLocation != null
                          ? _locations[_selectedLocation]!.map((sub) {
                            return DropdownMenuItem<String>(
                              value: sub,
                              alignment: AlignmentDirectional.centerEnd,
                              child: Text(sub, textAlign: TextAlign.right),
                            );
                          }).toList()
                          : [],
                  onChanged: (value) {
                    setState(() {
                      _selectedSubLocation = value;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // دکمه مشاهده
          ElevatedButton(
            onPressed:
                _selectedLocation != null && _selectedSubLocation != null
                    ? _goToNearbyPage
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(80, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'مشاهده',
                  style: TextStyle(fontFamily: 'Vazir', fontSize: 11),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToNearbyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DeliveryNearbyPage(
              location: _selectedLocation!,
              subLocation: _selectedSubLocation!,
            ),
      ),
    );
  }
}
