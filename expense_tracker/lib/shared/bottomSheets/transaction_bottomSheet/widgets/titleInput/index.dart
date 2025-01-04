import 'package:expense_tracker/features/transactions/models/transaction.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({
    super.key,
    required this.transactionType,
    required this.titleInputController,
  });

  final String transactionType;
  final TextEditingController titleInputController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        controller: titleInputController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: transactionType == TransactionType.expense ? 'Expense' : "Income",
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
