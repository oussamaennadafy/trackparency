import 'package:expense_tracker/shared/components/drop_downs/drop_down_menu.dart';
import 'package:expense_tracker/shared/components/switchers/tab_button.dart';
import 'package:expense_tracker/shared/components/switchers/tab_switcher.dart';
// import 'package:expense_tracker/theme/colors.dart';
// import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  const Filter({
    super.key,
    required this.selectedTab,
    required this.selectedMonth,
    required this.tabs,
    required this.months,
    required this.onMonthSelect,
  });

  final String selectedMonth;
  final String selectedTab;
  final List<TabButton> tabs;
  final List<String> months;
  final void Function(String month) onMonthSelect;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          TabSwitcher(
            selectedTab: widget.selectedTab,
            tabs: widget.tabs,
          ),
          const SizedBox(width: 8),
          DropDownMenu(
            options: widget.months,
            onSelect: widget.onMonthSelect,
            selectedOption: widget.selectedMonth,
          ),
        ],
      ),
    );
  }
}
