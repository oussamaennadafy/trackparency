import 'dart:async';

import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/index.dart';
import 'package:expense_tracker/shared/components/list_tiles/list_tile.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:expense_tracker/utils/formaters/formate_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            return Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: AppColors.green,
                    icon: Icons.edit,
                    label: "edit",
                    onPressed: (context) {
                      TransactionBottomSheet.edit(context, appState.transactions[index]);
                    },
                    padding: const EdgeInsets.all(4.0),
                  ),
                  SlidableAction(
                    backgroundColor: AppColors.red,
                    icon: Icons.delete,
                    label: "delete",
                    onPressed: (context) {
                      handleDelete(appState.transactions[index]);
                    },
                    padding: const EdgeInsets.all(4.0),
                  ),
                ],
              ),
              child: AppListTile(
                title: appState.transactions[index].title.toString(),
                icon: appState.transactions[index].type == TransactionType.expense ? Icons.arrow_downward : Icons.arrow_upward,
                iconBackgroundColor: appState.transactions[index].type == TransactionType.expense ? AppColors.red : AppColors.green,
                trailingTitle: appState.transactions[index].price.toString(),
                trailingSubTitle: formateDate(appState.transactions[index].timestamp),
                titleStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
