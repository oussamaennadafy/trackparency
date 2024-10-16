import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.trailingTitle,
    this.subTitle,
    this.trailingSubTitle,
    this.onTap,
    this.titleStyle,
  });

  final dynamic icon;
  final Color iconBackgroundColor;
  final String title;
  final String? subTitle;
  final String trailingTitle;
  final String? trailingSubTitle;
  final GestureTapCallback? onTap;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                color: iconBackgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(9999),
                ),
              ),
              child: icon is String ? SvgPicture.asset(icon) : Icon(icon),
            ),
            const SizedBox(width: 16),
            // Title and subtitle
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ).merge(titleStyle),
                  ),
                  if (subTitle != null)
                    Text(
                      subTitle!,
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
                    const Text(
                      "DH",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trailingTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                if (trailingSubTitle != null)
                  Text(
                    trailingSubTitle!,
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
    );
  }
}
