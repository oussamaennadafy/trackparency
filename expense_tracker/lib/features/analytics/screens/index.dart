import 'package:expense_tracker/features/analytics/widgets/index/cards/index.dart';
import 'package:expense_tracker/features/analytics/widgets/index/categorie_tiles/index.dart';
import 'package:expense_tracker/features/analytics/widgets/index/chart/index.dart';
import 'package:expense_tracker/features/analytics/widgets/index/filter/index.dart';
import 'package:expense_tracker/features/analytics/widgets/index/header/index.dart';
import 'package:expense_tracker/shared/components/switchers/tab_button.dart';
import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  String selectedTab = "EXPENSES";
  String selectedMonth = "SEPTEMBER";

  final months = [
    "JANUARY",
    "FEBRUARY",
    "MARCH",
    "APRIL",
    "MAY",
    "JUNE",
    "JULY",
    "AUGUST",
    "SEPTEMBER",
    "OCTOBER",
    "NOVEMBER",
    "DECEMBER"
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
      body: Column(
        children: [
          const Header(),
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
