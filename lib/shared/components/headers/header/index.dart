import 'package:animated_digit/animated_digit.dart';
import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/transactions/models/transaction.dart';
import 'package:expense_tracker/shared/bottomSheets/transaction_bottomSheet/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4, right: 4, bottom: 4, top: MediaQuery.of(context).padding.top + 4),
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      AnimatedDigitWidget(
                        value: appState.balance,
                        enableSeparator: true,
                        separateSymbol: " ",
                        textStyle: const TextStyle(
                          fontSize: 22,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "DH",
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
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
