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
    required this.selectedPaymentMethod,
    required this.onCategorySelect,
    required this.selectedCategory,
  });

  final String transactionType;
  final String selectedPaymentMethod;
  final String selectedCategory;
  final void Function(String newSelectedPaymentMethod) onPaymentMethodSelect;
  final void Function(String newSelectedPaymentMethod) onCategorySelect;

  @override
  State<TransactionDropDowns> createState() => _TransactionDropDownsState();
}

class _TransactionDropDownsState extends State<TransactionDropDowns> {
  late List<DropDownItem> categories = [];

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
                widget.onPaymentMethodSelect(selectedOption);
              },
              selectedOption: widget.selectedPaymentMethod,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropDownMenu(
              options: categories,
              onSelect: (selectedOption) {
                widget.onCategorySelect(selectedOption);
              },
              selectedOption: widget.selectedCategory,
            ),
          ),
        ],
      ),
    );
  }
}
