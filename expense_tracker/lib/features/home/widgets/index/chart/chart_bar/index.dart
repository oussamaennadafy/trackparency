import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.color,
    required this.heightFactor,
    required this.label,
    required this.value,
  });

  final Color color;
  final double heightFactor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      alignment: Alignment.bottomCenter,
                      heightFactor: heightFactor,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 20,
                                // height: 20,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(9999),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: constraints.minHeight,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.gray,
              ),
            )
          ],
        ),
      ),
    );
  }
}
