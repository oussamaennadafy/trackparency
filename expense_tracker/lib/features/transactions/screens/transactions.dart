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

  bool deleteLoading = false;

  void clearRemovedItem() {
    removedItemIndex = null;
    removedItem = null;
  }

  // delete Transaction Permanently
  Future<void> deleteTransactionPermanently(Transaction transaction) async {
    // Get the ApplicationState instance
    final applicationState = Provider.of<ApplicationState>(context, listen: false);
    // Call and await addExpense
    await applicationState.deleteTransaction(transaction);
  }

  // void deleteTransactionTemporary(Transaction transaction, index) {
  //   // Get the ApplicationState instance
  //   final applicationState = Provider.of<ApplicationState>(context, listen: false);
  //   removedItem = transaction;
  //   removedItemIndex = index;
  //   setState(() {
  //     applicationState.transactions.removeAt(index);
  //   });

  //   // update balance
  //   applicationState.updateBalanceSync(
  //     actionType: TransactionActions.delete,
  //     amount: transaction.price,
  //     transactionType: transaction.type,
  //   );
  // }

  // void handleUndo() {
  //   // if we dont have deleted item
  //   if (removedItemIndex == null && removedItem == null) return;
  //   // Get the ApplicationState instance
  //   final applicationState = Provider.of<ApplicationState>(context, listen: false);
  //   final transactions = applicationState.transactions;
  //   setState(() {
  //     transactions.insert(removedItemIndex!, removedItem!);
  //   });
  //   // update balance
  //   applicationState.updateBalanceSync(
  //     actionType: TransactionActions.add,
  //     amount: removedItem!.price,
  //     transactionType: removedItem!.type,
  //   );
  //   // we empty the removedItemIndex and removedItem
  //   clearRemovedItem();
  // }

  // Future<void> checkifDeletionOngoin() async {
  //   if (removedItem != null && removedItemIndex != null) {
  //     await deleteTransactionPermanently(removedItem!);
  //     ScaffoldMessenger.of(context).clearSnackBars();
  //     clearRemovedItem();
  //   }
  // }

  // Future<void> onDeletePress(Transaction transaction, int index) async {
  // // check if deletion ongoin
  // await checkifDeletionOngoin();
  // // remove it locally
  // deleteTransactionTemporary(transaction, index);
  // // show snackbar to give user acces to undo
  // if (mounted) {
  //   final snackBar = ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Expense deleted successfully'),
  //       duration: const Duration(seconds: 4),
  //       action: SnackBarAction(
  //         label: "undo",
  //         onPressed: handleUndo,
  //       ),
  //     ),
  //   );
  //   snackBar.closed.then((reason) {
  //     if (reason == SnackBarClosedReason.action) return;
  //     if (reason == SnackBarClosedReason.hide) return;
  //     deleteTransactionPermanently(transaction);
  //   });
  // }
  // }

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
                      deleteTransactionPermanently(transaction);
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
