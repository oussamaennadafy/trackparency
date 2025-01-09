import 'package:animated_digit/animated_digit.dart';
import 'package:expense_tracker/features/categories/utils/get_icon_from_string.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/utils/formaters/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedAppListTile extends StatefulWidget {
  const AnimatedAppListTile({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.trailingTitle,
    this.subTitle,
    this.trailingSubTitle,
    this.onTap,
    this.titleStyle,
    this.isTrailingTitleAnimated,
    required this.index,
  });

  final String icon;
  final Color iconBackgroundColor;
  final String title;
  final String? subTitle;
  final int trailingTitle;
  final String? trailingSubTitle;
  final GestureTapCallback? onTap;
  final TextStyle? titleStyle;
  final bool? isTrailingTitleAnimated;
  final int index;

  @override
  State<AnimatedAppListTile> createState() => _AnimatedAppListTileState();
}

class _AnimatedAppListTileState extends State<AnimatedAppListTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    initializeAnimation();
  }

  void initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    // _playAnimation();
    _animationController.value = 1;
  }

  void _playAnimation() {
    _animationController.reset();
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      _animationController.forward();
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedAppListTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check for relevant prop changes that should trigger animation
    if (oldWidget.trailingTitle != widget.trailingTitle || oldWidget.title != widget.title || oldWidget.icon != widget.icon || oldWidget.iconBackgroundColor != widget.iconBackgroundColor) {
      _playAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leading icon
              Container(
                padding: const EdgeInsets.all(14.0),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: widget.iconBackgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(9999),
                  ),
                ),
                child: widget.icon.startsWith("assets/icons/") ? SvgPicture.asset(widget.icon) : Icon(getIconFromString(widget.icon)),
              ),
              const SizedBox(width: 16),
              // Title and subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ).merge(widget.titleStyle),
                    ),
                    if (widget.subTitle != null)
                      Text(
                        widget.subTitle!,
                        style: const TextStyle(
                          color: AppColors.gray,
                        ),
                      ),
                  ],
                ),
              ),
              // Trailing
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.isTrailingTitleAnimated == true
                          ? AnimatedDigitWidget(
                              value: widget.trailingTitle,
                              enableSeparator: true,
                              separateSymbol: " ",
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            )
                          : Text(
                              formatePrice(widget.trailingTitle),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                      const SizedBox(width: 2),
                      const Text(
                        "DH",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (widget.trailingSubTitle != null)
                    Text(
                      widget.trailingSubTitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value,
          child: SlideTransition(
            position: Tween(
              begin: Offset(0.3, 0),
              end: Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
