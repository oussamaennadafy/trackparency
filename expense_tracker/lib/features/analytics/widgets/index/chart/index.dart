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
              ChartBar(
                color: AppColors.red,
                heightFactor: 0.60,
                label: "1",
              ),
              ChartBar(
                color: AppColors.blue,
                heightFactor: 0.25,
                label: "2",
              ),
              ChartBar(
                color: AppColors.yellow,
                heightFactor: 0.40,
                label: "3",
              ),
              ChartBar(
                color: AppColors.green,
                heightFactor: 0.7,
                label: "4",
              ),
              ChartBar(
                color: AppColors.violet,
                heightFactor: 0.74,
                label: "5",
              ),
              ChartBar(
                color: AppColors.lightBlue,
                heightFactor: 0.60,
                label: "6",
              ),
              ChartBar(
                color: AppColors.pink,
                heightFactor: 0.77,
                label: "7",
              ),
              ChartBar(
                color: AppColors.orange,
                heightFactor: 0.35,
                label: "8",
              ),
              ChartBar(
                color: AppColors.lavenderGray,
                heightFactor: 0.25,
                label: "9",
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 23.0),
            color: AppColors.extraLightGray,
            height: 1,
          ),
        ],
      ),
    );
  }
}
