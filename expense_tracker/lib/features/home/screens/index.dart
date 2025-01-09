import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/enums/index.dart';
import 'package:expense_tracker/features/home/widgets/index/cards/index.dart';
import 'package:expense_tracker/features/home/widgets/index/categorie_tiles/index.dart';
import 'package:expense_tracker/features/home/widgets/index/chart/index.dart';
import 'package:expense_tracker/features/home/widgets/index/filter/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/switchers/tab_switcher/classes/tab_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String selectedMonth = Months.values[DateTime.now().month - 1].toString().split(".")[1].toLowerCase();
  late DateFrame selectedCard;

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

  void onTabPress(TabButton tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<ApplicationState>(context, listen: false);
    selectedCard = appState.selectedDateFrame;
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
          ),
          const Chart(),
          const Cards(),
          const CategoryTiles(),
        ],
      ),
    );
  }
}
