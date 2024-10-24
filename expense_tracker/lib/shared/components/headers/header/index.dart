import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/tabs/transactions/models/transaction.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/utils/formaters/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: IconButton(
              color: AppColors.primary,
              icon: const Icon(Icons.add),
              onPressed: () {
                TransactionBottomSheet.add(context, TransactionType.income);
              },
            ),
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) {
              if (appState.isBalanceLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${formatePrice(appState.balance)} DH",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          "Total Balance",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gray,
                          ),
                        ),
                        Icon(Icons.expand_more)
                      ],
                    ),
                  ],
                );
              }
            },
          ),
          Center(
            child: IconButton(
              color: AppColors.primary,
              icon: const Icon(Icons.remove),
              onPressed: () {
                TransactionBottomSheet.add(context, TransactionType.expense);
              },
            ),
          ),
        ],
      ),
    );
  }
}
