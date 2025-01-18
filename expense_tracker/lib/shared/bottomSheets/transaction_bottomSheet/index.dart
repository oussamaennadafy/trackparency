import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/transactions/models/transaction.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/data/drop_down_items.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/widgets/commentInput/index.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/widgets/dragHandler/index.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/widgets/keyboard/index.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/widgets/priceText/index.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/widgets/titleInput/index.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/widgets/transactionDropDowns/index.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
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
  }
}

class TransactioneBottomSheetState extends State<TransactionBottomSheet> {
  String? selectedPaymentMethod;
  String? selectedCategory;
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
    // add case
    if (widget.transaction != null) {
      price = widget.transaction!.price.toString();
      _titleInputController.text = widget.transaction!.title;
      _commentInputController.text = widget.transaction!.comment;
      selectedDate = widget.transaction!.timestamp;
    } else {
      // edit case
      price = "0";
      selectedDate = DateTime.now();
    }
  }

  void onPaymentMethodSelect(String newSelectedPaymentMethod) {
    selectedPaymentMethod = newSelectedPaymentMethod;
  }

  void onCategorySelect(String newSelectedCategory) {
    selectedCategory = newSelectedCategory;
  }

  String validatePrice(character) {
    var newValue = price;

    if ((price + character) != "0" && isPriceInvalid == true) {
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
          paymentMethod: selectedPaymentMethod!,
          category: selectedCategory!,
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
          selectedDate.month - 7,
          selectedDate.day,
        ),
        lastDate: DateTime(
          selectedDate.year,
          selectedDate.month + 7,
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

    // if (price.length == 6) return price;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build whole bottomsheet...");
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(
          Radius.circular(28),
        ),
      ),
      margin: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const DragHandler(),
          Expanded(
            flex: 2,
            child: TransactionDropDowns(
              transactionType: widget.type,
              onPaymentMethodSelect: onPaymentMethodSelect,
              onCategorySelect: onCategorySelect,
              transaction: widget.transaction,
            ),
          ),
          Expanded(
            child: TitleInput(
              transactionType: widget.type,
              titleInputController: _titleInputController,
            ),
          ),
          PriceText(
            price: price,
            isPriceInvalid: isPriceInvalid,
          ),
          CommentInput(
            commentInputController: _commentInputController,
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
