import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SubTableWidget extends StatelessWidget {
  final int parentId;
  final List<Map<String, dynamic>> subItems;
  final Map<int, String> subFieldStatuses;
  final List<String> statusOptions;
  final int? sortColumnIndex;
  final bool isAscending;
  final Function(int) onSort;
  final Function(int, String) onStatusChange;

  const SubTableWidget({
    super.key,
    required this.parentId,
    required this.subItems,
    required this.subFieldStatuses,
    required this.statusOptions,
    required this.sortColumnIndex,
    required this.isAscending,
    required this.onSort,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildHeader(),
          ...subItems.map((subItem) => _buildRow(subItem)).toList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          color: AppColors.primaryGreen,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _buildSortableHeader('تاریخ درخواست', flex: 2, index: 0),
                _buildDivider(),
                _buildSortableHeader('عنوان کالا', flex: 2, index: 1),
                _buildDivider(),
                _buildSortableHeader('نوع درخواست', flex: 2, index: 2),
                _buildDivider(),
                _buildSortableHeader('مبلغ فعلی', flex: 2, index: 3),
                _buildDivider(),
                _buildSortableHeader('مبلغ درخواست شده', flex: 2, index: 4),
                _buildDivider(),
                _buildSortableHeader('وضعیت تایید', flex: 2, index: 5),
              ],
            ),
          ),
        ),
        Container(height: 1, color: Colors.white.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildRow(Map<String, dynamic> subItem) {
    return Column(
      children: [
        Container(
          color: const Color(0xFFE8E8E8),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _buildSubCell(subItem['request_date'], flex: 2),
                _buildDivider(dark: true),
                _buildSubCell(subItem['product_name'], flex: 2),
                _buildDivider(dark: true),
                _buildSubCell(subItem['request_type'], flex: 2),
                _buildDivider(dark: true),
                _buildSubCell(subItem['current_price'].toString(), flex: 2),
                _buildDivider(dark: true),
                _buildSubCell(subItem['requested_price'].toString(), flex: 2),
                _buildDivider(dark: true),
                _buildDropdownCell(),
              ],
            ),
          ),
        ),
        Container(height: 1, color: Colors.white.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildSortableHeader(
    String text, {
    required int flex,
    required int index,
  }) {
    final isActive = sortColumnIndex == index;
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => onSort(index),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isActive
                  ? (isAscending ? Icons.arrow_upward : Icons.arrow_downward)
                  : Icons.unfold_more,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Vazir',
          fontSize: 11,
          color: Colors.black87,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDropdownCell() {
    return Expanded(
      flex: 2,
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
              value: subFieldStatuses[parentId],
              dropdownColor: Colors.white,
              isDense: true,
              alignment: Alignment.centerRight,
              style: const TextStyle(
                fontFamily: 'Vazir',
                fontSize: 9,
                color: Colors.black87,
              ),
              selectedItemBuilder: (BuildContext context) {
                return statusOptions.skip(1).map((String value) {
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              items:
                  statusOptions.skip(1).map((String value) {
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
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onStatusChange(parentId, newValue);
                }
              },
            ),
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
}
