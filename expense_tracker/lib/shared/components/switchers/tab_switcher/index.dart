import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class TabSwitcher extends StatefulWidget {
  const TabSwitcher({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabPress,
  });

  final List<String> tabs;
  final String selectedTab;
  final void Function(String tab) onTabPress;

  @override
  State<TabSwitcher> createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> with SingleTickerProviderStateMixin {
  late AnimationController _sliderAnimationController;

  @override
  void initState() {
    super.initState();
    _sliderAnimationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: widget.tabs.length.toDouble(),
      duration: Duration(milliseconds: 200),
    );
    _sliderAnimationController.value = widget.tabs.indexOf(widget.selectedTab).toDouble();
  }

  @override
  void dispose() {
    _sliderAnimationController.dispose();
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
                                  animation: _sliderAnimationController,
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
                                      translation: Offset(_sliderAnimationController.value, 0),
                                      child: child,
                                    );
                                  },
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                widget.onTabPress(entry.value);
                                _sliderAnimationController.animateTo(1);
                                _sliderAnimationController.animateTo(
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
                                      entry.value,
                                      style: TextStyle(
                                        color: entry.value == widget.selectedTab ? AppColors.onSurface : AppColors.primary,
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
