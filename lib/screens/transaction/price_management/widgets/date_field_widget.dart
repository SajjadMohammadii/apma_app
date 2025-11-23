import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DateFieldWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const DateFieldWidget({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today,
              size: 12,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Vazir',
                fontSize: 9,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
