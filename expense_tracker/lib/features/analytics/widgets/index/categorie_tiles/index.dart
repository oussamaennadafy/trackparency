import 'package:expense_tracker/shared/components/list_tiles/list_tile.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';

class CategoryTiles extends StatelessWidget {
  const CategoryTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: AppListTile(
              icon: AppIcons.tShirt,
              iconBackgroundColor: AppColors.green,
              title: "Shopping",
              subTitle: "Cash",
              trailingTitle: "498.50",
              trailingSubTitle: "32%",
              onTap: () {
                print("Shopping");
              },
            ),
          ),
          Expanded(
            child: AppListTile(
              icon: AppIcons.gift,
              iconBackgroundColor: AppColors.violet,
              title: "Gifts",
              subTitle: "Cash . Card",
              trailingTitle: "344.45",
              trailingSubTitle: "21%",
              onTap: () {
                print("Gifts");
              },
            ),
          ),
          Expanded(
            child: AppListTile(
              icon: AppIcons.pizza,
              iconBackgroundColor: AppColors.red,
              title: "Food",
              subTitle: "Cash",
              trailingTitle: "230.50",
              trailingSubTitle: "12%",
              onTap: () {
                print("Food");
              },
            ),
          ),
        ],
      ),
    );
  }
}
