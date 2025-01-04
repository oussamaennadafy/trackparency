import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class DragHandler extends StatelessWidget {
  const DragHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 3,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: AppColors.gray,
      ),
    );
  }
}
