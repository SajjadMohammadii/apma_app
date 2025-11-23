import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FilterButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const FilterButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 16, color: AppColors.primaryGreen),
            SizedBox(width: 4),
            Text(
              'فیلتر',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
