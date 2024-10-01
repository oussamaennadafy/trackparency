import 'package:expense_tracker/shared/utils/formaters/capitalize_first_letter.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
    required this.options,
    required this.onSelect,
    required this.selectedOption,
  });

  final List<String> options;
  final void Function(String) onSelect;
  final String selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.onSurface,
        borderRadius: BorderRadius.circular(9999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        alignment: Alignment.center,
        value: selectedOption,
        icon: const Icon(Icons.expand_more),
        iconSize: 24,
        elevation: 2,
        style: const TextStyle(
          color: Colors.black,
        ),
        underline: Container(
          height: 0,
          color: Colors.transparent,
        ),
        onChanged: (value) {
          if (value != null) onSelect(value);
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              capitalizeFirstLetter(value),
              // style: GoogleFonts.fredoka(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
