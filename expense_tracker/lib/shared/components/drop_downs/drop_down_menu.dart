import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/utils/formaters/capitalize_first_letter.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
    required this.options,
    required this.onSelect,
    required this.selectedOption,
  });

  final List<DropDownItem> options;
  final void Function(String) onSelect;
  final String selectedOption;

  @override
  Widget build(BuildContext context) {
    final selectedObject = options.where((element) => element.label == selectedOption).first;

    return Container(
      decoration: BoxDecoration(
        color: selectedObject.backgroundColor ?? AppColors.onSurface,
        borderRadius: BorderRadius.circular(9999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: DropdownButtonHideUnderline(
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
              return IntrinsicWidth(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedObject.icon != null) ...[
                      SvgPicture.asset(selectedObject.icon!),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        textAlign: TextAlign.center,
                        capitalizeFirstLetter(item.label),
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
              child: Text(capitalizeFirstLetter(value.label)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
