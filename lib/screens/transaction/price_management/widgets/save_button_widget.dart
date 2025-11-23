import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SaveButtonWidget extends StatelessWidget {
  final bool hasChanges;
  final VoidCallback onTap;

  const SaveButtonWidget({
    super.key,
    required this.hasChanges,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: hasChanges ? AppColors.primaryPurple : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Center(
            child: Text(
              'ذخیره',
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
    );
  }
}
