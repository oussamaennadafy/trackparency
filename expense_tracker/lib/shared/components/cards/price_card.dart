import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({
    super.key,
    required this.label,
    required this.price,
  });

  final String label;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: const BoxDecoration(
            color: AppColors.onSurface,
            borderRadius: BorderRadius.all(
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
                      const Text(
                        "\$",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
