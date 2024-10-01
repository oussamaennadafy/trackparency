import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.color,
    required this.heightFactor,
    required this.label,
  });

  final Color color;
  final double heightFactor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: heightFactor,
              child: Column(
                children: [
                  Text(
                    "${(heightFactor * 100).toInt()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 20,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(9999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
