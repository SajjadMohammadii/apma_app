import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

class PersianDatePickerDialog extends StatefulWidget {
  final String initialDate;
  final Function(String) onDateSelected;

  const PersianDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<PersianDatePickerDialog> createState() =>
      _PersianDatePickerDialogState();

  // متد استاتیک برای نمایش دیالوگ
  static Future<String?> show(BuildContext context, String initialDate) async {
    String? selectedDate;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PersianDatePickerDialog(
          initialDate: initialDate,
          onDateSelected: (date) {
            selectedDate = date;
          },
        );
      },
    );
    return selectedDate;
  }
}

class _PersianDatePickerDialogState extends State<PersianDatePickerDialog> {
  late Jalali selectedDate;

  @override
  void initState() {
    super.initState();
    try {
      List<String> parts = widget.initialDate.split('/');
      selectedDate = Jalali(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (e) {
      selectedDate = Jalali.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              _buildHeader(),
              const SizedBox(height: 6),
              _buildWeekDays(),
              const Divider(height: 12),
              _buildCalendar(),
              const SizedBox(height: 16),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 24),
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.addMonths(-1);
              });
            },
          ),
          Text(
            '${selectedDate.formatter.mN} ${selectedDate.year}',
            style: const TextStyle(
              fontFamily: 'Vazir',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 24),
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.addMonths(1);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    return Row(
      children:
          ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 130,
      child: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final firstDayOfMonth = Jalali(
              selectedDate.year,
              selectedDate.month,
              1,
            );
            final weekDay = firstDayOfMonth.weekDay;
            final daysInMonth = selectedDate.monthLength;

            if (index < weekDay || index >= weekDay + daysInMonth) {
              return const SizedBox.shrink();
            }

            final day = index - weekDay + 1;
            final isSelected = day == selectedDate.day;
            final isToday =
                Jalali.now().year == selectedDate.year &&
                Jalali.now().month == selectedDate.month &&
                Jalali.now().day == day;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedDate = Jalali(
                      selectedDate.year,
                      selectedDate.month,
                      day,
                    );
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.primaryGreen
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border:
                        isToday && !isSelected
                            ? Border.all(
                              color: AppColors.primaryGreen,
                              width: 2,
                            )
                            : null,
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 13,
                        color:
                            isSelected
                                ? Colors.white
                                : isToday
                                ? AppColors.primaryGreen
                                : Colors.black87,
                        fontWeight:
                            isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey.shade400),
              padding: const EdgeInsets.symmetric(vertical: 6),
              minimumSize: const Size(0, 32),
            ),
            child: const Text(
              'انصراف',
              style: TextStyle(fontFamily: 'Vazir', fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              String formatted =
                  '${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}';
              widget.onDateSelected(formatted);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              backgroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 6),
              minimumSize: const Size(0, 32),
            ),
            child: const Text(
              'تأیید',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
