import 'dart:io';
import 'package:apma_app/core/constants/app_colors.dart';
import 'package:apma_app/screens/transaction/bankcheck/camera_preview_screen.dart';
import 'package:apma_app/shared/widgets/persian_date_picker/persian_date_picker_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:flutter/services.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  String checkActionType = "دریافت چک";
  String? imagePath;
  List<CameraDescription>? _cameras;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController sayadiController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  final ThousandsSeparatorInputFormatter _amountFormatter =
      ThousandsSeparatorInputFormatter();

  bool get _isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  bool get _isDesktopOrWeb {
    if (kIsWeb) return true;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  @override
  void initState() {
    super.initState();
    _setTodayDate();
  }

  void _setTodayDate() {
    final now = Jalali.now();
    dateController.text =
        '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _openDatePicker() async {
    final selectedDate = await PersianDatePickerDialog.show(
      context,
      dateController.text,
    );
    if (selectedDate != null) {
      dateController.text = selectedDate;
    }
  }

  Future<void> _openAttachment() async {
    if (_isDesktopOrWeb) {
      // فقط گزینه فایل در دسکتاپ و وب
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() => imagePath = file.path);
      }
    } else {
      // در موبایل هم فایل هم دوربین
      _showAttachmentPicker();
    }
  }

  void _showAttachmentPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'انتخاب فایل پیوست',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPickerOption(
                        icon: Icons.camera_alt,
                        label: 'دوربین',
                        onTap: () async {
                          Navigator.pop(context);
                          await _openCamera();
                        },
                      ),
                      _buildPickerOption(
                        icon: Icons.photo_library,
                        label: 'گالری',
                        onTap: () async {
                          Navigator.pop(context);
                          final XFile? file = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (file != null) {
                            setState(() => imagePath = file.path);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryPurple, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Vazir',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => CameraPreviewScreen(
              camera: _cameras!.first,
              onCapture: (path) => setState(() => imagePath = path),
            ),
      ),
    );
  }

  void _saveData() {
    print("اطلاعات مشتری ذخیره شد");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _openAttachment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("آپلود چک", style: TextStyle(fontFamily: 'Vazir')),
                      SizedBox(width: 12),
                      Icon(Icons.upload_file),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (imagePath != null) _uploadedFileBox(),
                _buildDropdownField("نوع چک", checkActionType, [
                  "دریافت چک",
                  "ارسال چک",
                ]),
                _buildField("تاریخ", dateController, isDate: true),
                _buildField(
                  "شماره چک / شماره سریال",
                  numberController,
                  isNumeric: true,
                ),
                _buildField("صیادی", sayadiController, isNumeric: true),
                _buildField("مبلغ", priceController, isAmount: true),
                _buildField("شرکت", companyController),
              ],
            ),
          ),
        ),
        _saveButton(),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Vazir",
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              style: const TextStyle(
                fontFamily: "Vazir",
                fontSize: 14,
                color: Colors.black87,
              ),
              dropdownColor: Colors.white,
              items:
                  items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      alignment: Alignment.centerRight,
                      child: Text(item, textAlign: TextAlign.right),
                    );
                  }).toList(),
              onChanged: (val) => setState(() => checkActionType = val!),
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool isNumeric = false,
    bool isDate = false,
    bool isAmount = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Vazir",
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child:
              isDate
                  ? InkWell(
                    onTap: _openDatePicker,
                    child: IgnorePointer(
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: "Vazir",
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  )
                  : TextField(
                    controller: controller,
                    textAlign: TextAlign.right,
                    keyboardType:
                        isNumeric || isAmount
                            ? TextInputType.number
                            : TextInputType.text,
                    inputFormatters:
                        isAmount
                            ? [_amountFormatter]
                            : isNumeric
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : [],
                    style: const TextStyle(fontFamily: "Vazir", fontSize: 15),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _uploadedFileBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "فایل چک",
          style: TextStyle(
            fontFamily: "Vazir",
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: const [
              Icon(Icons.insert_drive_file, color: Colors.blue, size: 35),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "فایل چک آپلود شد",
                  style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _saveData,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "ذخیره",
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    String raw = newValue.text.replaceAll(",", "");
    if (int.tryParse(raw) == null) return oldValue;

    String formatted = raw.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => "${m[1]},",
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
