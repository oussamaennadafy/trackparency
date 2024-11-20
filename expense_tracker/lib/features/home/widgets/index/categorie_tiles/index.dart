import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/shared/components/list_tiles/list_tile.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTiles extends StatelessWidget {
  const CategoryTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<ApplicationState>(
        builder: (context, appState, _) => appState.isTopThreeSpendingCategoriesLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: appState.topThreeSpendingCategories.map((el) {
                  return Expanded(
                    child: AppListTile(
                      icon: el.icon,
                      iconBackgroundColor: AppColors().get(el.color),
                      title: el.name,
                      subTitle: "Cash",
                      trailingTitle: el.total.toString(),
                      trailingSubTitle: "${el.percentage?.toStringAsFixed(2)}%",
                      onTap: () {},
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
