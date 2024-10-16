import 'dart:developer';

import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/shared/bottomSheets/add_expense_bottomSheet/keyboard/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/drop_downs/drop_down_menu.dart';
import 'package:expense_tracker/shared/components/texts/shake_text.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseBottomSheet extends StatefulWidget {
  const ExpenseBottomSheet({
    super.key,
    this.expense,
  });

  final Expense? expense;

  @override
  State<ExpenseBottomSheet> createState() => _ExpenseBottomSheetState();

  // Add this static method
  static void add(
    BuildContext context, {
    double maxHeightRatio = 0.9,
    bool useSafeArea = true,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: useSafeArea,
      scrollControlDisabledMaxHeightRatio: maxHeightRatio,
      builder: (context) => const ExpenseBottomSheet(),
    );
  }

  static void edit(
    BuildContext context,
    Expense expense, {
    double maxHeightRatio = 0.9,
    bool useSafeArea = true,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: useSafeArea,
      scrollControlDisabledMaxHeightRatio: maxHeightRatio,
      builder: (context) => ExpenseBottomSheet(expense: expense),
    );
  }
}

class _ExpenseBottomSheetState extends State<ExpenseBottomSheet> {
  late String selectedPaymentMethod;
  late String selectedCategory;
  late String price;
  late DateTime selectedDate;
  bool isLoading = false;
  bool isPriceInvalid = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      selectedPaymentMethod = widget.expense!.paymentMethod;
      selectedCategory = widget.expense!.category;
      price = widget.expense!.price.toString();
      titleInputController.text = widget.expense!.title;
      commentInputController.text = widget.expense!.comment;
      selectedDate = widget.expense!.timestamp;
    } else {
      selectedPaymentMethod = "Cash";
      selectedCategory = "Food";
      price = "0";
      selectedDate = DateTime.now();
    }
  }

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

    if ((price + character) != "0") {
      setState(() {
        isPriceInvalid = false;
      });
    }

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
        if (price == "0") {
          setState(() {
            isPriceInvalid = true;
          });
          return newValue;
        }
        // handle submittion
        handleSubmit(
          paymentMethod: selectedPaymentMethod,
          category: selectedCategory,
          title: titleInputController.text,
          price: price,
          comment: commentInputController.text,
          date: selectedDate,
        );
      }
      return newValue;
    }

    if (character == "calendar") {
      // open calendar
      showDatePicker(
        context: context,
        firstDate: DateTime(
          selectedDate.year,
          selectedDate.month - 1,
          selectedDate.day,
        ),
        lastDate: DateTime(
          selectedDate.year,
          selectedDate.month + 1,
          selectedDate.day,
        ),
        initialDate: selectedDate,
        // currentDate: selectedDate,
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
      ).then((pickedDate) {
        if (pickedDate != null && pickedDate != selectedDate) {
          selectedDate = pickedDate;
        }
      });
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

  Future<void> handleSubmit({
    required String paymentMethod,
    required String category,
    required String title,
    required String price,
    required String comment,
    required DateTime date,
  }) async {
    // if (widget.expense != null)
    // start loading
    setState(() {
      isLoading = true;
    });
    try {
      // Get the ApplicationState instance
      final applicationState = Provider.of<ApplicationState>(context, listen: false);

      final newExpanse = Expense(
        id: widget.expense?.id,
        paymentMethod: paymentMethod,
        category: category,
        title: title != "" ? title : "Expense",
        price: int.parse(price), // Convert price to int
        comment: comment,
        timestamp: date,
      );

      if (widget.expense != null) {
        // Call and await updateExpense
        await applicationState.updateExpense(newExpanse);
      } else {
        // Call and await addExpense
        await applicationState.addExpense(newExpanse);
      }

      // If successful, show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: widget.expense != null ? const Text('Expense updated successfully') : const Text('Expense added successfully'),
          ),
        );
      }
    } catch (e) {
      // If there's an error, show an error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: widget.expense != null ? Text('Error updating expense $e') : Text('Expense adding expense $e')),
        );
      }
    } finally {
      // stop loading
      setState(() {
        isLoading = false;
      });
      // Close bottomSheet, whether successful or not
      if (mounted) {
        Navigator.pop(context);
      }
    }
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
                          label: "Gifts",
                          backgroundColor: AppColors.violet,
                          icon: AppIcons.gift,
                        ),
                        DropDownItem(
                          label: "Food",
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
                  child: isPriceInvalid
                      ? ShakeWidget(
                          child: Text(
                            "DH",
                            style: TextStyle(
                              fontSize: 28,
                              color: isPriceInvalid ? Colors.red.shade400 : AppColors.gray,
                            ),
                          ),
                        )
                      : Text(
                          "DH",
                          style: TextStyle(
                            fontSize: 28,
                            color: isPriceInvalid ? Colors.red.shade400 : AppColors.gray,
                          ),
                        ),
                ),
                const SizedBox(width: 4),
                isPriceInvalid
                    ? ShakeWidget(
                        child: Text(
                          price,
                          style: TextStyle(
                            fontSize: 54,
                            color: isPriceInvalid ? Colors.red : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Text(
                        price,
                        style: TextStyle(
                          fontSize: 54,
                          color: isPriceInvalid ? Colors.red : AppColors.primary,
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
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
