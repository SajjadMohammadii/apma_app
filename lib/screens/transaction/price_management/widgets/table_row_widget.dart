import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TableRowWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isExpanded;
  final VoidCallback onTap;

  const TableRowWidget({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            color: AppColors.primaryPurple,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item['id']}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Vazir',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDivider(),
                  _buildCell(item['date'], flex: 2),
                  _buildDivider(),
                  _buildCell(item['number'], flex: 2),
                  _buildDivider(),
                  _buildCell(item['customer'], flex: 3),
                  _buildDivider(),
                  _buildCell(item['issuer'], flex: 2),
                ],
              ),
            ),
          ),
          Container(height: 1, color: Colors.white.withOpacity(0.3)),
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
        style: const TextStyle(
          fontFamily: 'Vazir',
          fontSize: 12,
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, color: Colors.white.withOpacity(0.3));
  }
}
