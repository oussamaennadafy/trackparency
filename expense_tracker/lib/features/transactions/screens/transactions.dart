import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/transactions/widgets/slidable_item.dart';
import 'package:expense_tracker/shared/components/list_tiles/list_tile.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Scaffold(
        body: ListView.builder(
          itemCount: appState.transactions.length,
          prototypeItem: const AppListTile(
            title: "Expense",
            icon: AppIcons.analytics,
            iconBackgroundColor: AppColors.green,
            trailingTitle: "30",
          ),
          itemBuilder: (context, index) {
            return SlidableItem(
              context: context,
              item: appState.transactions[index],
            );
          },
        ),
      ),
    );
  }
}
