import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/transactions/models/transaction.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/data/drop_down_items.dart';
import 'package:expense_tracker/shared/components/drop_downs/classes/drop_down_item.dart';
import 'package:expense_tracker/shared/components/drop_downs/drop_down_menu.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionDropDowns extends StatefulWidget {
  const TransactionDropDowns({
    super.key,
    required this.transactionType,
    required this.onPaymentMethodSelect,
    required this.onCategorySelect,
    required this.transaction,
  });

  final String transactionType;
  final void Function(String newSelectedPaymentMethod) onPaymentMethodSelect;
  final void Function(String newSelectedPaymentMethod) onCategorySelect;
  final Transaction? transaction;

  @override
  State<TransactionDropDowns> createState() => _TransactionDropDownsState();
}

class _TransactionDropDownsState extends State<TransactionDropDowns> {
  late List<DropDownItem> categories = [];
  late String selectedPaymentMethod;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    // define vriables based on transaction type
    if (widget.transactionType == TransactionType.expense) {
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
    } else if (widget.transactionType == TransactionType.income) {
      categories = incomeCategories;
    }

    // add case
    if (widget.transaction != null) {
      selectedPaymentMethod = widget.transaction!.paymentMethod;
      selectedCategory = widget.transaction!.category;
    } else {
      // edit case
      selectedPaymentMethod = widget.transactionType == TransactionType.expense ? "Cash" : "Card";
      selectedCategory = widget.transactionType == TransactionType.expense ? categories.first.label : "Salary";
    }

    // set data in parent
    widget.onPaymentMethodSelect(selectedPaymentMethod);
    widget.onCategorySelect(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: DropDownMenu(
              options: paymentMethods,
              onSelect: (selectedOption) {
                setState(() {
                  selectedPaymentMethod = selectedOption;
                });
                widget.onPaymentMethodSelect(selectedOption);
              },
              selectedOption: selectedPaymentMethod,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropDownMenu(
              options: categories,
              onSelect: (selectedOption) {
                setState(() {
                  selectedCategory = selectedOption;
                });
                widget.onCategorySelect(selectedOption);
              },
              selectedOption: selectedCategory,
            ),
          ),
        ],
      ),
    );
  }
}
