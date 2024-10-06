import 'dart:developer';

import 'package:animated_digit/animated_digit.dart';
import 'package:expense_tracker/shared/bottomSheets/add_expense_bottomSheet/keyboard/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/drop_downs/drop_down_menu.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddExpenseBottomSheet extends StatefulWidget {
  const AddExpenseBottomSheet({super.key});

  @override
  State<AddExpenseBottomSheet> createState() => _AddExpenseBottomSheetState();
}

class _AddExpenseBottomSheetState extends State<AddExpenseBottomSheet> {
  String selectedPaymentMethod = "Cash";
  String selectedCategory = "Shopping";
  String price = "0";

  void onPaymentMethodSelect(String newSelectedPaymentMethod) {
    setState(() {
      selectedPaymentMethod = newSelectedPaymentMethod;
    });
  }

  void onCategorySelect(String newSelectedCategory) {
    setState(() {
      selectedCategory = newSelectedCategory;
    });
  }

  String validatePrice(character) {
    var newValue = price;
    // check for clear
    if (character == "clear") {
      if (price.length == 1) return "0";
      newValue = price.substring(0, price.length - 1);
      return newValue;
    }
    // check for check
    if (character == "check") {
      if (price.contains("+")) {
        var sum = 0.0;
        var list = price.split("+");
        for (var i = 0; i < list.length; i++) {
          if (list[i] == "") continue;
          sum += double.parse(list[i]);
        }
        newValue = sum.toStringAsFixed(0);
      } else {
        // handle submittion
        handleSubmit(
          paymentMethod: selectedPaymentMethod,
          category: selectedCategory,
          title: titleInputController.text,
          price: price,
          comment: commentInputController.text,
          date: DateTime.now(),
        );
      }
      return newValue;
    }

    if (character == "calendar") {
      final date = DateTime.now();
      // open calendar
      showDatePicker(
        context: context,
        firstDate: DateTime(
          date.year,
          date.month - 1,
          date.day,
        ),
        lastDate: DateTime(
          date.year,
          date.month + 1,
          date.day,
        ),
        initialDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                onPrimary: AppColors.surface,
                onBackground: AppColors.surface,
              ),
              datePickerTheme: const DatePickerThemeData(
                headerBackgroundColor: AppColors.lavenderGray,
                backgroundColor: AppColors.surface,
                headerForegroundColor: AppColors.surface,
                surfaceTintColor: AppColors.surface,
                rangeSelectionBackgroundColor: AppColors.red,
              ),
            ),
            child: child!,
          );
        },
      );
      return price;
    }

    if (character == "AC") return "0";

    if (price[price.length - 1] == "+" && character == "0") return price;

    if (price[price.length - 1] == "+" && character == "+") return price;

    if (price == "0" && character == "0") return price;

    if (price == "0" && character == "+") return price;

    if (price == "0") return character;

    newValue += character;

    return newValue;
  }

  void onkeyboardPress(String character) {
    // set state to the new price
    setState(() {
      price = validatePrice(character);
    });
  }

  void handleSubmit({
    required String paymentMethod,
    required String category,
    required String title,
    required String price,
    required String comment,
    DateTime? date,
  }) {
    debugPrint({
      paymentMethod,
      category,
      title,
      price,
      comment,
      date,
    }.toString());
  }

  final titleInputController = TextEditingController();
  final commentInputController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleInputController.dispose();
    commentInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(
          Radius.circular(28),
        ),
      ),
      margin: const EdgeInsets.all(6.0),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 35,
            height: 3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: AppColors.gray,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropDownMenu(
                      options: const [
                        DropDownItem(
                          label: "Cash",
                          backgroundColor: AppColors.blue,
                          icon: AppIcons.cash,
                        ),
                        DropDownItem(
                          label: "Card",
                          backgroundColor: AppColors.lavenderGray,
                          icon: AppIcons.creditCard,
                        ),
                      ],
                      onSelect: (selectedOption) {
                        onPaymentMethodSelect(selectedOption);
                      },
                      selectedOption: selectedPaymentMethod,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropDownMenu(
                      options: const [
                        DropDownItem(
                          label: "Shopping",
                          backgroundColor: AppColors.green,
                          icon: AppIcons.tShirt,
                        ),
                        DropDownItem(
                          label: "gifts",
                          backgroundColor: AppColors.violet,
                          icon: AppIcons.gift,
                        ),
                        DropDownItem(
                          label: "food",
                          backgroundColor: AppColors.red,
                          icon: AppIcons.pizza,
                        ),
                      ],
                      onSelect: (selectedOption) {
                        onCategorySelect(selectedOption);
                      },
                      selectedOption: selectedCategory,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: TextField(
                controller: titleInputController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Expense',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                    )),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: const Text(
                    "DH",
                    style: TextStyle(
                      fontSize: 28,
                      color: AppColors.gray,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 54,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: TextField(
                controller: commentInputController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add comment...',
                ),
              ),
            ),
          ),
          AppKeyboard(
            handleItemPress: onkeyboardPress,
          ),
        ],
      ),
    );
  }
}
