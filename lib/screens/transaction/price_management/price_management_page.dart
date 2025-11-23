import 'package:apma_app/core/constants/app_colors.dart';
import 'package:apma_app/screens/transaction/price_management/widgets/advanced_filter_dialog.dart';
import 'package:apma_app/screens/transaction/price_management/widgets/date_field_widget.dart';
import 'package:apma_app/screens/transaction/price_management/widgets/filter_button_widget.dart';
import 'package:apma_app/screens/transaction/price_management/widgets/save_button_widget.dart';
import 'package:apma_app/screens/transaction/price_management/widgets/status_dropdown_widget.dart';
import 'package:apma_app/screens/transaction/price_management/widgets/sub_table_widget.dart';
import 'package:apma_app/screens/transaction/price_management/widgets/table_header_widget.dart';
import 'package:apma_app/screens/transaction/price_management/widgets/table_row_widget.dart';
import 'package:apma_app/shared/widgets/persian_date_picker/persian_date_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceManagementPage extends StatefulWidget {
  const PriceManagementPage({super.key});

  @override
  State<PriceManagementPage> createState() => _PriceManagementPageState();
}

class _PriceManagementPageState extends State<PriceManagementPage> {
  // State variables
  String selectedStatus = 'در حال بررسی';
  Map<int, String> subFieldStatuses = {};
  final List<String> statusOptions = [
    'همه',
    'در حال بررسی',
    'تایید شده',
    'رد شده',
  ];
  Set<int> expandedRows = {};
  bool hasChanges = false;

  // Sort variables
  int? sortColumnIndex;
  bool isAscending = true;
  Map<int, int?> subSortColumnIndex = {};
  Map<int, bool> subIsAscending = {};

  // Filter dates
  String fromDate = '1403/08/01';
  String toDate = '1403/08/30';

  // Filter controllers
  final TextEditingController _numberFilterController = TextEditingController();
  final TextEditingController _customerFilterController =
      TextEditingController();
  final TextEditingController _issuerFilterController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();
  String selectedSearchMode = 'AND';

  // Data
  List<Map<String, dynamic>> mainData = [
    {
      'id': 1,
      'date': '1403/08/28',
      'number': '24536',
      'customer': 'شرکت داروسازی کاسپین',
      'issuer': 'بهار دولتی',
    },
    {
      'id': 2,
      'date': '1403/08/27',
      'number': '24537',
      'customer': 'شرکت پخش البرز',
      'issuer': 'علی احمدی',
    },
    {
      'id': 3,
      'date': '1403/08/26',
      'number': '24538',
      'customer': 'شرکت داروپخش',
      'issuer': 'سارا رضایی',
    },
    {
      'id': 4,
      'date': '1403/08/25',
      'number': '24539',
      'customer': 'شرکت پخش رازی',
      'issuer': 'محمد کریمی',
    },
    {
      'id': 5,
      'date': '1403/08/24',
      'number': '24540',
      'customer': 'شرکت داروپخش سپهر',
      'issuer': 'زهرا محمدی',
    },
    {
      'id': 6,
      'date': '1403/08/23',
      'number': '24541',
      'customer': 'شرکت داروسازی تهران',
      'issuer': 'حسن رضایی',
    },
  ];

  List<Map<String, dynamic>> filteredData = [];

  Map<int, List<Map<String, dynamic>>> subData = {
    1: [
      {
        'request_date': '1403/08/28',
        'product_name': 'محصول الف',
        'request_type': 'افزایش قیمت',
        'current_price': 150000,
        'requested_price': 180000,
        'approval_status': 'در حال بررسی',
      },
      {
        'request_date': '1403/08/29',
        'product_name': 'محصول ب',
        'request_type': 'کاهش قیمت',
        'current_price': 200000,
        'requested_price': 180000,
        'approval_status': 'تایید شده',
      },
    ],
    2: [
      {
        'request_date': '1403/08/27',
        'product_name': 'محصول ج',
        'request_type': 'افزایش قیمت',
        'current_price': 300000,
        'requested_price': 350000,
        'approval_status': 'رد شده',
      },
    ],
    3: [
      {
        'request_date': '1403/08/26',
        'product_name': 'محصول د',
        'request_type': 'کاهش قیمت',
        'current_price': 400000,
        'requested_price': 350000,
        'approval_status': 'در حال بررسی',
      },
    ],
    4: [
      {
        'request_date': '1403/08/25',
        'product_name': 'محصول ه',
        'request_type': 'افزایش قیمت',
        'current_price': 500000,
        'requested_price': 550000,
        'approval_status': 'تایید شده',
      },
    ],
    5: [
      {
        'request_date': '1403/08/24',
        'product_name': 'محصول و',
        'request_type': 'افزایش قیمت',
        'current_price': 250000,
        'requested_price': 280000,
        'approval_status': 'در حال بررسی',
      },
    ],
    6: [
      {
        'request_date': '1403/08/23',
        'product_name': 'محصول ز',
        'request_type': 'کاهش قیمت',
        'current_price': 600000,
        'requested_price': 550000,
        'approval_status': 'تایید شده',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeData();
  }

  void _initializeData() {
    for (var item in mainData) {
      subFieldStatuses[item['id']] = 'در حال بررسی';
      subSortColumnIndex[item['id']] = null;
      subIsAscending[item['id']] = true;
    }
    filteredData = List.from(mainData);
    _applyFilters();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _numberFilterController.dispose();
    _customerFilterController.dispose();
    _issuerFilterController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  // Select date
  Future<void> _selectDate(bool isFromDate) async {
    final selectedDate = await PersianDatePickerDialog.show(
      context,
      isFromDate ? fromDate : toDate,
    );
    if (selectedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDate = selectedDate;
        } else {
          toDate = selectedDate;
        }
        _applyFilters();
      });
    }
  }

  // Apply filters
  void _applyFilters() {
    setState(() {
      filteredData =
          mainData.where((item) {
            bool statusMatch =
                selectedStatus == 'همه' ||
                _getItemStatus(item['id']) == selectedStatus;
            bool dateMatch = _isDateInRange(item['date'], fromDate, toDate);
            bool numberMatch =
                _numberFilterController.text.isEmpty ||
                item['number'].toString().contains(
                  _numberFilterController.text,
                );
            bool customerMatch =
                _customerFilterController.text.isEmpty ||
                item['customer'].toString().toLowerCase().contains(
                  _customerFilterController.text.toLowerCase(),
                );
            bool issuerMatch =
                _issuerFilterController.text.isEmpty ||
                item['issuer'].toString().toLowerCase().contains(
                  _issuerFilterController.text.toLowerCase(),
                );
            bool keywordMatch = _checkKeywordMatch(item);

            return statusMatch &&
                dateMatch &&
                numberMatch &&
                customerMatch &&
                issuerMatch &&
                keywordMatch;
          }).toList();
    });
  }

  bool _checkKeywordMatch(Map<String, dynamic> item) {
    if (_keywordsController.text.trim().isEmpty) return true;

    List<String> keywords =
        _keywordsController.text
            .trim()
            .split(RegExp(r'[,\s]+'))
            .where((k) => k.isNotEmpty)
            .map((k) => k.toLowerCase())
            .toList();

    if (keywords.isEmpty) return true;

    String searchableText =
        [
          item['customer'].toString(),
          item['number'].toString(),
          item['issuer'].toString(),
          item['date'].toString(),
        ].join(' ').toLowerCase();

    if (selectedSearchMode == 'AND') {
      return keywords.every((keyword) => searchableText.contains(keyword));
    } else {
      return keywords.any((keyword) => searchableText.contains(keyword));
    }
  }

  String _getItemStatus(int itemId) {
    return subFieldStatuses[itemId] ?? 'در حال بررسی';
  }

  bool _isDateInRange(String dateStr, String fromStr, String toStr) {
    try {
      List<String> dateParts = dateStr.split('/');
      List<String> fromParts = fromStr.split('/');
      List<String> toParts = toStr.split('/');

      int dateInt =
          int.parse(dateParts[0]) * 10000 +
          int.parse(dateParts[1]) * 100 +
          int.parse(dateParts[2]);
      int fromInt =
          int.parse(fromParts[0]) * 10000 +
          int.parse(fromParts[1]) * 100 +
          int.parse(fromParts[2]);
      int toInt =
          int.parse(toParts[0]) * 10000 +
          int.parse(toParts[1]) * 100 +
          int.parse(toParts[2]);

      return dateInt >= fromInt && dateInt <= toInt;
    } catch (e) {
      return true;
    }
  }

  void _showAdvancedFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AdvancedFilterDialog(
            numberController: _numberFilterController,
            customerController: _customerFilterController,
            issuerController: _issuerFilterController,
            keywordsController: _keywordsController,
            initialSearchMode: selectedSearchMode,
            onApply: (searchMode) {
              setState(() {
                selectedSearchMode = searchMode;
              });
              _applyFilters();
            },
            onClear: () {
              setState(() {
                _numberFilterController.clear();
                _customerFilterController.clear();
                _issuerFilterController.clear();
                _keywordsController.clear();
                selectedSearchMode = 'AND';
              });
              _applyFilters();
            },
          ),
    );
  }

  // Sort main table
  void _sortMainTable(int columnIndex) {
    setState(() {
      if (sortColumnIndex == columnIndex) {
        isAscending = !isAscending;
      } else {
        sortColumnIndex = columnIndex;
        isAscending = true;
      }

      filteredData.sort((a, b) {
        dynamic aValue;
        dynamic bValue;

        switch (columnIndex) {
          case 0:
            aValue = a['id'];
            bValue = b['id'];
            break;
          case 1:
            aValue = a['date'];
            bValue = b['date'];
            break;
          case 2:
            aValue = a['number'];
            bValue = b['number'];
            break;
          case 3:
            aValue = a['customer'];
            bValue = b['customer'];
            break;
          case 4:
            aValue = a['issuer'];
            bValue = b['issuer'];
            break;
          default:
            return 0;
        }

        int comparison;
        if (aValue is int && bValue is int) {
          comparison = aValue.compareTo(bValue);
        } else {
          comparison = aValue.toString().compareTo(bValue.toString());
        }

        return isAscending ? comparison : -comparison;
      });
    });
  }

  // Sort sub table
  void _sortSubTable(int parentId, int columnIndex) {
    setState(() {
      if (subSortColumnIndex[parentId] == columnIndex) {
        subIsAscending[parentId] = !(subIsAscending[parentId] ?? true);
      } else {
        subSortColumnIndex[parentId] = columnIndex;
        subIsAscending[parentId] = true;
      }

      if (subData.containsKey(parentId)) {
        final ascending = subIsAscending[parentId] ?? true;
        subData[parentId]!.sort((a, b) {
          dynamic aValue;
          dynamic bValue;

          switch (columnIndex) {
            case 0:
              aValue = a['request_date'];
              bValue = b['request_date'];
              break;
            case 1:
              aValue = a['product_name'];
              bValue = b['product_name'];
              break;
            case 2:
              aValue = a['request_type'];
              bValue = b['request_type'];
              break;
            case 3:
              aValue = a['current_price'];
              bValue = b['current_price'];
              break;
            case 4:
              aValue = a['requested_price'];
              bValue = b['requested_price'];
              break;
            case 5:
              aValue = a['approval_status'];
              bValue = b['approval_status'];
              break;
            default:
              return 0;
          }

          int comparison;
          if (aValue is int && bValue is int) {
            comparison = aValue.compareTo(bValue);
          } else {
            comparison = aValue.toString().compareTo(bValue.toString());
          }

          return ascending ? comparison : -comparison;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.primaryGreen,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      automaticallyImplyLeading: true,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            DateFieldWidget(
              text: 'از: $fromDate',
              onTap: () => _selectDate(true),
            ),
            const SizedBox(width: 8),
            DateFieldWidget(
              text: 'تا: $toDate',
              onTap: () => _selectDate(false),
            ),
            const SizedBox(width: 8),
            FilterButtonWidget(onTap: _showAdvancedFilterDialog),
            const SizedBox(width: 8),
            StatusDropdownWidget(
              selectedStatus: selectedStatus,
              statusOptions: statusOptions,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                  _applyFilters();
                }
              },
            ),
            const SizedBox(width: 8),
            SaveButtonWidget(
              hasChanges: hasChanges,
              onTap: () {
                setState(() {
                  hasChanges = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تغییرات ذخیره شد')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
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
            TableHeaderWidget(
              sortColumnIndex: sortColumnIndex,
              isAscending: isAscending,
              onSort: _sortMainTable,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child:
                    filteredData.isEmpty
                        ? const Center(
                          child: Text(
                            'داده‌ای یافت نشد',
                            style: TextStyle(
                              fontFamily: 'Vazir',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            final item = filteredData[index];
                            final isExpanded = expandedRows.contains(
                              item['id'],
                            );
                            return Column(
                              children: [
                                TableRowWidget(
                                  item: item,
                                  isExpanded: isExpanded,
                                  onTap: () {
                                    setState(() {
                                      if (isExpanded) {
                                        expandedRows.remove(item['id']);
                                      } else {
                                        expandedRows.add(item['id']);
                                      }
                                    });
                                  },
                                ),
                                if (isExpanded) ...[
                                  const SizedBox(height: 8),
                                  if (subData.containsKey(item['id']))
                                    SubTableWidget(
                                      parentId: item['id'],
                                      subItems: subData[item['id']]!,
                                      subFieldStatuses: subFieldStatuses,
                                      statusOptions: statusOptions,
                                      sortColumnIndex:
                                          subSortColumnIndex[item['id']],
                                      isAscending:
                                          subIsAscending[item['id']] ?? true,
                                      onSort:
                                          (index) =>
                                              _sortSubTable(item['id'], index),
                                      onStatusChange: (id, status) {
                                        setState(() {
                                          subFieldStatuses[id] = status;
                                          hasChanges = true;
                                        });
                                      },
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
    );
  }
}
