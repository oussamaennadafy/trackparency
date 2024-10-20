import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({
    super.key,
    required this.label,
    required this.price,
    this.border,
  });

  final String label;
  final String price;
  final bool? border;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Ink(
        decoration: BoxDecoration(
          border: border == true
              ? Border.all(
                  color: AppColors.lightGray,
                  width: 1,
                )
              : Border.all(
                  color: Colors.transparent,
                  width: 1,
                ),
          color: AppColors.onSurface,
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () {
            print(label);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
            child: Column(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      "DH",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
