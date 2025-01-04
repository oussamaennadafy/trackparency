import 'package:expense_tracker/shared/components/switchers/tab_switcher/classes/tab_button.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class TabSwitcher extends StatefulWidget {
  const TabSwitcher({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabPress,
  });

  final List<TabButton> tabs;
  final TabButton selectedTab;
  final void Function(TabButton tab) onTabPress;

  @override
  State<TabSwitcher> createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: widget.tabs.length.toDouble(),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                .toList()
                .asMap()
                .entries
                .map(
                  (entry) => Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            if (entry.key == 0)
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(9999),
                                      ),
                                    ),
                                  ),
                                  builder: (context, child) {
                                    return FractionalTranslation(
                                      translation: Offset(_animationController.value, 0),
                                      child: child,
                                    );
                                  },
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                widget.onTabPress(entry.value);
                                _animationController.animateTo(
                                  entry.key.toDouble(),
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                );
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(9999),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      entry.value.label,
                                      style: TextStyle(
                                        color: entry.value.id == widget.selectedTab.id ? AppColors.onSurface : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
