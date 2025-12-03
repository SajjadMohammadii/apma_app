import 'package:apma_app/core/constants/app_colors.dart';
import 'package:apma_app/screens/transaction/bankcheck/bank/bank.dart';
import 'package:apma_app/screens/transaction/bankcheck/custumer/customer.dart';
import 'package:flutter/material.dart';

class BankCheckPage extends StatefulWidget {
  const BankCheckPage({super.key});

  @override
  State<BankCheckPage> createState() => _BankCheckPageState();
}

class _BankCheckPageState extends State<BankCheckPage> {
  String selectedCheckType = 'مشتری';
  final List<String> checkTypes = ['مشتری', 'بانک'];

  @override
  Widget build(BuildContext context) {
    bool isCustomer = selectedCheckType == "مشتری";
    bool isBank = selectedCheckType == "بانک";

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: _buildMainDropdown(),
        ),
        body:
            isCustomer
                ? const CustomerPage()
                : isBank
                ? const BankPage()
                : Container(),
      ),
    );
  }

  Widget _buildMainDropdown() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCheckType,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          style: const TextStyle(
            fontFamily: "Vazir",
            fontSize: 14,
            color: AppColors.primaryPurple,
          ),
          dropdownColor: Colors.white,
          items:
              checkTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  alignment: Alignment.centerRight,
                  child: Text(type, textAlign: TextAlign.right),
                );
              }).toList(),
          onChanged: (value) {
            setState(() => selectedCheckType = value!);
          },
        ),
      ),
    );
  }
}
