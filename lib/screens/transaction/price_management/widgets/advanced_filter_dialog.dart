import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AdvancedFilterDialog extends StatefulWidget {
  final TextEditingController numberController;
  final TextEditingController customerController;
  final TextEditingController issuerController;
  final TextEditingController keywordsController;
  final String initialSearchMode;
  final Function(String) onApply;
  final VoidCallback onClear;

  const AdvancedFilterDialog({
    super.key,
    required this.numberController,
    required this.customerController,
    required this.issuerController,
    required this.keywordsController,
    required this.initialSearchMode,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<AdvancedFilterDialog> createState() => _AdvancedFilterDialogState();
}

class _AdvancedFilterDialogState extends State<AdvancedFilterDialog> {
  late String selectedSearchMode;

  @override
  void initState() {
    super.initState();
    selectedSearchMode = widget.initialSearchMode;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 400,
          constraints: const BoxConstraints(maxHeight: 550),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const Divider(height: 20),
                const SizedBox(height: 12),
                _buildFilterTextField(
                  'شماره پیش فاکتور',
                  widget.numberController,
                  Icons.numbers,
                ),
                const SizedBox(height: 12),
                _buildFilterTextField(
                  'نام مشتری',
                  widget.customerController,
                  Icons.person,
                ),
                const SizedBox(height: 12),
                _buildFilterTextField(
                  'صادرکننده',
                  widget.issuerController,
                  Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _buildKeywordFilter(),
                const SizedBox(height: 20),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'فیلتر پیشرفته',
          style: TextStyle(
            fontFamily: 'Vazir',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildKeywordFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'جستجو بر اساس کلمات کلیدی',
          style: TextStyle(
            fontFamily: 'Vazir',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: widget.keywordsController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: AppColors.primaryGreen,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryGreen),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            hintText: 'مثال: کاسپین البرز (کلمات را با فاصله جدا کنید)',
            hintStyle: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 10,
              color: Colors.grey.shade400,
            ),
          ),
          style: const TextStyle(fontFamily: 'Vazir', fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildSearchModeOption('AND', 'همه کلمات (و)')),
            const SizedBox(width: 8),
            Expanded(child: _buildSearchModeOption('OR', 'هر کدام (یا)')),
          ],
        ),
        const SizedBox(height: 8),
        _buildInfoBox(),
      ],
    );
  }

  Widget _buildSearchModeOption(String mode, String label) {
    final isSelected = selectedSearchMode == mode;
    return InkWell(
      onTap: () {
        setState(() {
          selectedSearchMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryGreen.withOpacity(0.1)
                  : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected ? AppColors.primaryGreen : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Vazir',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primaryGreen : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              selectedSearchMode == 'AND'
                  ? 'نتایج باید شامل تمام کلمات باشند'
                  : 'نتایج باید شامل حداقل یکی از کلمات باشند',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontSize: 10,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Vazir',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.primaryGreen),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryGreen),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            hintText: 'جستجو...',
            hintStyle: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 11,
              color: Colors.grey.shade400,
            ),
          ),
          style: const TextStyle(fontFamily: 'Vazir', fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              widget.onClear();
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'پاک کردن',
              style: TextStyle(fontFamily: 'Vazir', fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              widget.onApply(selectedSearchMode);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'اعمال فیلتر',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
