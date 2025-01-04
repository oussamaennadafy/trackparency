import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatefulWidget {
  const ChartBar({
    super.key,
    required this.color,
    required this.heightFactor,
    required this.label,
    required this.value,
  });

  final Color color;
  final double heightFactor;
  final String value;
  final String label;

  @override
  State<ChartBar> createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar> {
  double _currentHeightFactor = 0;

  @override
  void initState() {
    super.initState();
    // Schedule the animation to start after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentHeightFactor = widget.heightFactor;
      });
    });
  }

  @override
  void didUpdateWidget(ChartBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.heightFactor != widget.heightFactor) {
      setState(() {
        _currentHeightFactor = widget.heightFactor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      alignment: Alignment.bottomCenter,
                      heightFactor: _currentHeightFactor,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 20,
                                decoration: BoxDecoration(
                                  color: widget.color,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(9999),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: constraints.minHeight,
                                child: Text(
                                  widget.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.gray,
              ),
            )
          ],
        ),
      ),
    );
  }
}
