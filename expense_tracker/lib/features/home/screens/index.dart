import 'package:expense_tracker/features/home/widgets/index/cards/index.dart';
import 'package:expense_tracker/features/home/widgets/index/categorie_tiles/index.dart';
import 'package:expense_tracker/features/home/widgets/index/chart/index.dart';
import 'package:expense_tracker/features/home/widgets/index/filter/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  final List<String> homeTabs = const [
    "Expenses",
    "Income"
  ];

  final months = const [
    DropDownItem(label: "january"),
    DropDownItem(label: "february"),
    DropDownItem(label: "march"),
    DropDownItem(label: "april"),
    DropDownItem(label: "may"),
    DropDownItem(label: "june"),
    DropDownItem(label: "july"),
    DropDownItem(label: "august"),
    DropDownItem(label: "september"),
    DropDownItem(label: "october"),
    DropDownItem(label: "november"),
    DropDownItem(label: "december"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Filter(
            tabs: homeTabs,
            months: months,
          ),
          const Chart(),
          const Cards(),
          const CategoryTiles(),
        ],
      ),
    );
  }
}
