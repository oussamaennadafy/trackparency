import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/drop_downs/drop_down_menu.dart';
import 'package:expense_tracker/shared/components/switchers/tab_switcher/classes/tab_button.dart';
import 'package:expense_tracker/shared/components/switchers/tab_switcher/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Filter extends StatefulWidget {
  const Filter({
    super.key,
    required this.selectedTab,
    required this.tabs,
    required this.months,
    required this.onTabPress,
  });

  final TabButton selectedTab;
  final List<TabButton> tabs;
  final List<DropDownItem> months;
  final void Function(TabButton tab) onTabPress;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  void onMonthSelect(newSelectedMonth) async {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    appState.setSelectedMonth = newSelectedMonth;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          TabSwitcher(
            selectedTab: widget.selectedTab,
            tabs: widget.tabs,
            onTabPress: widget.onTabPress,
          ),
          const SizedBox(width: 8),
          Consumer<ApplicationState>(
            builder: (context, appState, _) {
              return DropDownMenu(
                options: widget.months,
                onSelect: onMonthSelect,
                selectedOption: appState.selectedMonth,
              );
            },
          ),
        ],
      ),
    );
  }
}
