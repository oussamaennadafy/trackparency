import 'package:expense_tracker/features/analytics/widgets/index/chart/chart_bar/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const Row(
            children: [
              ChartBar(),
              ChartBar(),
              ChartBar(),
              ChartBar(),
              ChartBar(),
              ChartBar(),
              ChartBar(),
              ChartBar(),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            color: AppColors.extraLightGray,
            height: 1,
          ),
        ],
      ),
    );
  }
}
