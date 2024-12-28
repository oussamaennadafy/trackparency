import 'package:expense_tracker/features/home/widgets/index/cards/index.dart';
import 'package:expense_tracker/features/home/widgets/index/categorie_tiles/index.dart';
import 'package:expense_tracker/features/home/widgets/index/chart/index.dart';
import 'package:expense_tracker/features/home/widgets/index/filter/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/switchers/tab_switcher/classes/tab_button.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TabButton> tabs = [
    const TabButton(
      id: "EXPENSES",
      label: "Expenses",
    ),
    const TabButton(
      id: "INCOME",
      label: "Income",
    ),
  ];
  late TabButton selectedTab;
  String selectedMonth = "SEPTEMBER";
  String selectedCard = "DAY";

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

  void onCardPress(String month) {
    setState(() {
      selectedCard = month;
    });
  }

  void onTabPress(TabButton tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedTab = tabs[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Filter(
            tabs: tabs,
            selectedTab: selectedTab,
            onTabPress: onTabPress,
            months: months,
            selectedMonth: selectedMonth,
            onMonthSelect: onMonthSelect,
          ),
          const Chart(),
          Cards(
            onCardPress: onCardPress,
            selectedCard: selectedCard,
          ),
          const CategoryTiles(),
        ],
      ),
    );
  }
}
