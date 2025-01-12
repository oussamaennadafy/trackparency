import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/home/data/chart_colors_list.dart';
import 'package:expense_tracker/features/home/utils/get_chart_height_factor.dart';
import 'package:expense_tracker/features/home/widgets/index/chart/chart_bar/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppColors.surface,
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) {
            return appState.chartDataLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Row(
                        children: appState.chartData!.resultsMap.toList().asMap().entries.map((e) {
                          return ChartBar(
                            color: chartBarColors[e.key],
                            heightFactor: getChartHeightFactor(e.value.value, appState.chartData!.biggestDay.total),
                            value: e.value.value.toString(),
                            label: e.value.key.toString(),
                          );
                        }).toList(),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 23.0),
                        color: AppColors.extraLightGray,
                        height: 1,
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
