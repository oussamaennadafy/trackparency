import 'package:expense_tracker/features/categories/utils/get_icon_from_string.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
    required this.options,
    required this.onSelect,
    required this.selectedOption,
    this.hasBorder,
  });

  final List<DropDownItem> options;
  final void Function(String) onSelect;
  final String selectedOption;
  final bool? hasBorder;

  @override
  Widget build(BuildContext context) {
    final selectedObject = options.where((element) => element.label == selectedOption).first;
    final dropdownWidth = MediaQuery.of(context).size.width * 0.3;

    return Container(
      decoration: BoxDecoration(
        color: selectedObject.backgroundColor ?? AppColors.onSurface,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          width: .5,
          color: hasBorder == true ? AppColors.primary : Colors.transparent,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: DropdownButtonHideUnderline(
        child: SizedBox(
          width: dropdownWidth,
          child: DropdownButton<String>(
            isDense: true,
            value: selectedOption,
            icon: const Icon(Icons.expand_more),
            iconSize: 24,
            elevation: 2,
            style: const TextStyle(color: Colors.black),
            onChanged: (value) {
              if (value != null) onSelect(value);
            },
            selectedItemBuilder: (BuildContext context) {
              return options.map<Widget>((DropDownItem item) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: dropdownWidth - 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedObject.icon?.startsWith("assets/icons/") == true) ...[
                        SvgPicture.asset(selectedObject.icon!),
                        const SizedBox(width: 4),
                      ] else ...[
                        if (selectedObject.icon != null) Icon(getIconFromString(selectedObject.icon!)),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          item.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            items: options.map<DropdownMenuItem<String>>((DropDownItem value) {
              return DropdownMenuItem<String>(
                value: value.label,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: dropdownWidth - 2),
                  child: Text(
                    value.label,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
