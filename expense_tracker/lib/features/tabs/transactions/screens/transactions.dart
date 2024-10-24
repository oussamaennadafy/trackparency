import 'dart:async';
import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/tabs/transactions/widgets/slidable_item.dart';
import 'package:expense_tracker/features/tabs/transactions/models/transaction.dart';
import 'package:expense_tracker/shared/components/list_tiles/list_tile.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/index.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  Future<void> handleDelete(Transaction transaction) async {
    // Get the ApplicationState instance
    final applicationState = Provider.of<ApplicationState>(context, listen: false);
    // Call and await addExpense
    await applicationState.deleteTransaction(transaction);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted successfully')),
      );
    }
  }

  void handleEdit(Transaction transaction) {
    TransactionBottomSheet.edit(context, transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Scaffold(
        body: ListView.builder(
          itemCount: appState.transactions.length,
          prototypeItem: const AppListTile(
            title: "Expense",
            icon: AppIcons.analytics,
            iconBackgroundColor: AppColors.blue,
            trailingTitle: "30",
          ),
          itemBuilder: (context, index) {
            return SlidableItem(
              item: appState.transactions[index],
              handleDelete: handleDelete,
              handleEdit: handleEdit,
            );
          },
        ),
      ),
    );
  }
}
