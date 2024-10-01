import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            "12%",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Container(
              width: 20,
              decoration: const BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(9999),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
