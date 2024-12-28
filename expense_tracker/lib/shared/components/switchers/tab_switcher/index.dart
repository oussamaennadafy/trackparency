import 'package:expense_tracker/shared/components/switchers/tab_switcher/classes/tab_button.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class TabSwitcher extends StatefulWidget {
  const TabSwitcher({
    super.key,
    required this.tabs,
    required this.selectedTab,
  });

  final List<TabButton> tabs;
  final String selectedTab;

  @override
  State<TabSwitcher> createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.onSurface,
          borderRadius: BorderRadius.all(
            Radius.circular(9999),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: widget.tabs
                .map(
                  (tab) => Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return InkWell(
                          onTap: () {
                            tab.onPressed();
                            print(constraints.minWidth);
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: tab.id == widget.selectedTab ? AppColors.primary : AppColors.onSurface,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(9999),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  tab.label,
                                  style: TextStyle(
                                    color: tab.id == widget.selectedTab ? AppColors.onSurface : AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
