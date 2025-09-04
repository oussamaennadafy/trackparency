import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyTransactionsState extends StatelessWidget {
  const EmptyTransactionsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppIllustrations.emptyList),
          const SizedBox(height: 24.0),
          const Text(
            "no transaction found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            "you don't have any transaction yet!",
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
