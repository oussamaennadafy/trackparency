import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/drop_downs/drop_down_menu.dart';
import 'package:expense_tracker/shared/components/switchers/tab_switcher/classes/tab_button.dart';
import 'package:expense_tracker/shared/components/switchers/tab_switcher/index.dart';
import 'package:flutter/material.dart';

class Filter extends StatelessWidget {
  const Filter({
    super.key,
    required this.selectedTab,
    required this.selectedMonth,
    required this.tabs,
    required this.months,
    required this.onMonthSelect,
    required this.onTabPress,
  });

  final String selectedMonth;
  final TabButton selectedTab;
  final List<TabButton> tabs;
  final List<DropDownItem> months;
  final void Function(String month) onMonthSelect;
  final void Function(TabButton tab) onTabPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          TabSwitcher(
            selectedTab: selectedTab,
            tabs: tabs,
            onTabPress: onTabPress,
          ),
          const SizedBox(width: 8),
          DropDownMenu(
            options: months,
            onSelect: onMonthSelect,
            selectedOption: selectedMonth,
          ),
        ],
      ),
    );
  }
}
