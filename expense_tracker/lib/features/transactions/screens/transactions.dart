import 'dart:async';
import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/transactions/widgets/empty_transactions_state.dart';
import 'package:expense_tracker/features/transactions/widgets/slidable_item.dart';
import 'package:expense_tracker/features/transactions/models/transaction.dart';
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
  Transaction? removedItem;
  int? removedItemIndex;
  // delete Transaction Permanently
  Future<void> deleteTransactionPermanently(Transaction transaction) async {
    // Get the ApplicationState instance
    final applicationState = Provider.of<ApplicationState>(context, listen: false);
    // Call and await addExpense
    await applicationState.deleteTransaction(transaction);
  }

  void deleteTransactionTemporary(Transaction transaction, index) {
    // Get the ApplicationState instance
    final applicationState = Provider.of<ApplicationState>(context, listen: false);
    final transactions = applicationState.transactions;
    removedItem = transaction;
    removedItemIndex = index;
    setState(() {
      removedItem = transactions.removeAt(index);
    });
  }

  void handleUndoDelete() {
    // if we dont have deleted item
    if (removedItemIndex == null && removedItem == null) return;
    // Get the ApplicationState instance
    final applicationState = Provider.of<ApplicationState>(context, listen: false);
    final transactions = applicationState.transactions;
    setState(() {
      transactions.insert(removedItemIndex!, removedItem!);
    });
    // we empty the removedItemIndex and removedItem
    removedItemIndex = null;
    removedItem = null;
  }

  Future<void> handleDelete(Transaction transaction, int index) async {
    // remove it locally
    deleteTransactionTemporary(transaction, index);
    // show snackbar to give user acces to undo
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      final snackBar = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Expense deleted successfully'),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: "undo",
            onPressed: handleUndoDelete,
          ),
        ),
      );
      snackBar.closed.then((reason) {
        if (reason == SnackBarClosedReason.action) return;
        deleteTransactionPermanently(transaction);
      });
    }
  }

  void handleEdit(Transaction transaction) {
    TransactionBottomSheet.edit(context, transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Scaffold(
        body: appState.transactions.isNotEmpty
            ? ListView.builder(
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
                    handleDelete: (transaction) {
                      handleDelete(transaction, index);
                    },
                    handleEdit: handleEdit,
                  );
                },
              )
            : const EmptyTransactionsState(),
      ),
    );
  }
}
