import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/transactions/models/transaction.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/data/drop_down_items.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/widgets/keyboard/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/drop_downs/drop_down_menu.dart';
import 'package:expense_tracker/shared/components/texts/shake_text.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/utils/formaters/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransactionBottomSheet extends StatefulWidget {
  const TransactionBottomSheet({
    super.key,
    required this.type,
    this.transaction,
  });

  final Transaction? transaction;
  final String type;

  @override
  State<TransactionBottomSheet> createState() => TransactioneBottomSheetState();

  static void add(
    BuildContext context,
    String type, {
    double maxHeightRatio = 0.9,
    bool useSafeArea = true,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: useSafeArea,
      scrollControlDisabledMaxHeightRatio: maxHeightRatio,
      builder: (context) => TransactionBottomSheet(type: type),
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(117, 255, 255, 255),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  static void edit(
    BuildContext context,
    Transaction transaction, {
    double maxHeightRatio = 0.9,
    bool useSafeArea = true,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: useSafeArea,
      scrollControlDisabledMaxHeightRatio: maxHeightRatio,
      builder: (context) => TransactionBottomSheet(
        transaction: transaction,
        type: transaction.type,
      ),
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(117, 255, 255, 255),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}

class TransactioneBottomSheetState extends State<TransactionBottomSheet> {
  late String selectedPaymentMethod;
  late String selectedCategory;
  late String price;
  late DateTime selectedDate;
  late List<DropDownItem> categories = [];
  bool isLoading = false;
  bool isPriceInvalid = false;
  final _titleInputController = TextEditingController();
  final _commentInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // define vriables based on transaction type
    if (widget.type == TransactionType.expense) {
      // categories = expenseCategories;
      final applicationState = Provider.of<ApplicationState>(context, listen: false);
      categories = applicationState.userSelectedCategories
          .map(
            (el) => DropDownItem(
              label: el.name,
              icon: el.icon,
              backgroundColor: AppColors().get(el.color),
            ),
          )
          .toList();
    } else if (widget.type == TransactionType.income) {
      categories = incomeCategories;
    }
    // define vriables based on action type : edit or creation
    if (widget.transaction != null) {
      selectedPaymentMethod = widget.transaction!.paymentMethod;
      selectedCategory = widget.transaction!.category;
      price = widget.transaction!.price.toString();
      _titleInputController.text = widget.transaction!.title;
      _commentInputController.text = widget.transaction!.comment;
      selectedDate = widget.transaction!.timestamp;
    } else {
      selectedPaymentMethod = widget.type == TransactionType.expense ? "Cash" : "Card";
      selectedCategory = widget.type == TransactionType.expense ? categories.first.label : "Salary";
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
          title: _titleInputController.text,
          price: price,
          comment: _commentInputController.text,
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
          selectedDate.month,
          selectedDate.day - 7,
        ),
        lastDate: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day + 7,
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
    // start loading
    setState(() {
      isLoading = true;
    });
    try {
      // Get the ApplicationState instance
      final applicationState = Provider.of<ApplicationState>(context, listen: false);

      final newTransaction = Transaction(
        id: widget.transaction?.id,
        paymentMethod: paymentMethod,
        category: category,
        title: title != "" ? title : (widget.type == TransactionType.expense ? "Expense" : "Income"),
        price: int.parse(price),
        comment: comment,
        timestamp: date,
        type: widget.type,
      );

      if (widget.transaction != null) {
        // Call and await updateTransaction
        applicationState.updateTransaction(
          widget.transaction as Transaction,
          newTransaction,
        );
      } else {
        // Call and await addTransaction
        applicationState.addTransaction(newTransaction);
      }

      // If successful, show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: widget.transaction != null ? const Text('Expense updated successfully') : const Text('Expense added successfully'),
          ),
        );
      }
    } catch (e) {
      // If there's an error, show an error message
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: widget.transaction != null ? Text('Error updating expense $e') : Text('Expense adding expense $e')),
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

  @override
  void dispose() {
    _titleInputController.dispose();
    _commentInputController.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.surface,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        // systemStatusBarContrastEnforced: true,
      ),
    );
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
                      options: paymentMethods,
                      onSelect: (selectedOption) {
                        onPaymentMethodSelect(selectedOption);
                      },
                      selectedOption: selectedPaymentMethod,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropDownMenu(
                      options: categories,
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
                controller: _titleInputController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.type == TransactionType.expense ? 'Expense' : "Income",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
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
                        price.contains("+") ? price : formatePrice(int.parse(price)),
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
                controller: _commentInputController,
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
