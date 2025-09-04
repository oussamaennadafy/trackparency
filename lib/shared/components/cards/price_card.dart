import 'package:animated_digit/animated_digit.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({
    super.key,
    required this.label,
    required this.price,
    this.onPress,
    this.border,
  });

  final String label;
  final String price;
  final bool? border;
  final GestureTapCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(
            color: border == true ? AppColors.lightGray : Colors.transparent,
            width: 1,
          ),
          color: AppColors.onSurface,
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: onPress,
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedDigitWidget(
                      value: int.tryParse(price) ?? 0,
                      enableSeparator: true,
                      separateSymbol: " ",
                      textStyle: const TextStyle(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
