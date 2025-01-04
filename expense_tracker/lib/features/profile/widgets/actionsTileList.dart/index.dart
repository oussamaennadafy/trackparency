import 'package:expense_tracker/shared/components/tiles/action_tile/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class ListData {
  const ListData({
    this.sectionTitle,
    required this.actionsList,
  });

  final String? sectionTitle;
  final List<ActionTile> actionsList;
}

class ActionsTileList extends StatelessWidget {
  const ActionsTileList({
    super.key,
    required this.listData,
  });

  final List<ListData> listData;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: listData
          .map(
            (item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.sectionTitle != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 6.0),
                    child: Text(
                      item.sectionTitle!,
                      style: TextStyle(
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                const SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 14.0),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: AppColors.onSurface,
                    border: Border.all(
                      color: AppColors.extraLightGray,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < item.actionsList.length; i++) ...[
                        ActionTile(
                          text: item.actionsList[i].text,
                          onPress: item.actionsList[i].onPress,
                          leftIcon: item.actionsList[i].leftIcon,
                          rightIcon: item.actionsList[i].rightIcon,
                          isDanger: item.actionsList[i].isDanger,
                        ),
                        if (i != item.actionsList.length - 1)
                          Divider(
                            color: AppColors.extraLightGray,
                            endIndent: 24.0,
                            indent: 24.0,
                          )
                      ]
                    ],
                  ),
                )
              ],
            ),
          )
          .toList(),
    );
  }
}
