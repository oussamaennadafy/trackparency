import 'package:expense_tracker/features/analytics/widgets/index/cards/index.dart';
import 'package:expense_tracker/features/analytics/widgets/index/categorie_tiles/index.dart';
import 'package:expense_tracker/features/analytics/widgets/index/chart/index.dart';
import 'package:expense_tracker/features/analytics/widgets/index/filter/index.dart';
import 'package:expense_tracker/shared/components/headers/header/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/switchers/tab_switcher/classes/tab_button.dart';
import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  String selectedTab = "EXPENSES";
  String selectedMonth = "SEPTEMBER";

  final months = const [
    DropDownItem(label: "JANUARY"),
    DropDownItem(label: "FEBRUARY"),
    DropDownItem(label: "MARCH"),
    DropDownItem(label: "APRIL"),
    DropDownItem(label: "MAY"),
    DropDownItem(label: "JUNE"),
    DropDownItem(label: "AUGUST"),
    DropDownItem(label: "SEPTEMBER"),
    DropDownItem(label: "OCTOBER"),
    DropDownItem(label: "NOVEMBER"),
    DropDownItem(label: "DECEMBER"),
  ];

  void onMonthSelect(String month) {
    setState(() {
      selectedMonth = month;
    });
  }

  late List<TabButton> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabButton(
        id: "EXPENSES",
        label: "Expenses",
        onPressed: () {
          setState(() {
            selectedTab = "EXPENSES";
          });
        },
      ),
      TabButton(
        id: "INCOME",
        label: "Income",
        onPressed: () {
          setState(() {
            selectedTab = "INCOME";
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // const Header(),
          Filter(
            tabs: tabs,
            selectedTab: selectedTab,
            months: months,
            selectedMonth: selectedMonth,
            onMonthSelect: onMonthSelect,
          ),
          const Chart(),
          const Cards(),
          const CategoryTiles(),
        ],
      ),
    );
  }
}
