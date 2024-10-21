import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/shared/bottomSheets/add_expense_bottomSheet/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  Future<void> handleMenuPress() async {
    // TODO: handle menu press
  }

  String formatBalance(int balance) {
    final formatter = NumberFormat("#,##0");
    return "${formatter.format(balance)} DH";
  }

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
              icon: SvgPicture.asset(AppIcons.menu),
              onPressed: handleMenuPress,
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
                      formatBalance(appState.balance),
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
              icon: const Icon(Icons.add),
              onPressed: () {
                ExpenseBottomSheet.add(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
