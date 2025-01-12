import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/enums/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/drop_downs/drop_down_menu.dart';
import 'package:expense_tracker/shared/components/switchers/tab_switcher/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Filter extends StatefulWidget {
  const Filter({
    super.key,
    required this.tabs,
    required this.months,
  });

  final List<String> tabs;
  final List<DropDownItem> months;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  void onMonthSelect(newSelectedMonth) async {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    appState.setSelectedMonth = newSelectedMonth;
  }

  void onTabSelect(String selectedTab) async {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    appState.setSelectedTab = selectedTab;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) {
            return Row(
              children: [
                TabSwitcher(
                  selectedTab: appState.selectedTab,
                  tabs: widget.tabs,
                  onTabPress: onTabSelect,
                ),
                const SizedBox(width: 8),
                DropDownMenu(
                  options: widget.months,
                  onSelect: onMonthSelect,
                  selectedOption: appState.selectedMonth,
                  hasBorder: Months.values[DateTime.now().month - 1].toString().split(".")[1] != appState.selectedMonth,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
