import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.text,
    this.leftIcon,
    this.rightIcon,
    required this.onPress,
    this.isDanger,
  });

  final String text;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final Function(BuildContext context) onPress;
  final bool? isDanger;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: () {
        onPress(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Icon(
                leftIcon,
                color: isDanger == true ? Colors.red : AppColors.primary,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isDanger == true ? Colors.red : AppColors.primary,
                ),
              ),
            ),
            Icon(
              rightIcon ?? Icons.arrow_forward,
              size: 18.0,
              color: isDanger == true ? Colors.red : AppColors.gray,
            ),
          ],
        ),
      ),
    );
  }
}
