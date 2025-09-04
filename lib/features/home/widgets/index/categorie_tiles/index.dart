import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/shared/components/tiles/animated_app_tile/index.dart';
// import 'package:expense_tracker/shared/components/tiles/app_tile/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTiles extends StatelessWidget {
  const CategoryTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: appState.topThreeSpendingCategories.toList().asMap().entries.map((el) {
            return Expanded(
              child: AnimatedAppListTile(
                index: el.key,
                icon: el.value.icon,
                iconBackgroundColor: el.value.color is String ? AppColors().get(el.value.color) : el.value.color,
                title: el.value.name,
                subTitle: "Cash",
                trailingTitle: el.value.total,
                trailingSubTitle: "${el.value.percentage?.toStringAsFixed(2)}%",
                onTap: () {},
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
