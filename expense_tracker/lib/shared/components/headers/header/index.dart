import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/shared/bottomSheets/add_expense_bottomSheet/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  Future<void> handleMenuPress() async {
    final titles = [
      "tacos",
      "shawarma",
      "taxi byad",
      "Expense",
      "serwal",
      "toast",
      "deodorant",
      "adapter",
      "mac",
      "gs 1250",
      "test"
    ];
    final paymentMethods = [
      "Cash",
      "Card"
    ];
    final categories = [
      "Shopping",
      "Gifts",
      "Food"
    ];
    final prices = [
      "15",
      "12",
      "5",
      "35",
      "40",
      "5",
      "100",
      "250",
      "80",
      "2000",
      "10",
      "18",
      "22000000",
      "234",
      "600",
      "66",
      "900"
    ];
    final comments = [
      "Shopping",
      "Gifts",
      "Food"
    ];

    for (int i = 0; i < 100; i++) {
      final newExpanse = Expense(
        paymentMethod: (paymentMethods..shuffle()).first,
        category: (categories..shuffle()).first,
        title: (titles..shuffle()).first,
        price: int.parse((prices..shuffle()).first), // Convert price to int
        comment: (comments..shuffle()).first,
        timestamp: DateTime.now(),
      );

      // Call and await addExpense
      await ApplicationState().addExpense(newExpanse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: SvgPicture.asset(AppIcons.menu),
            onPressed: handleMenuPress,
          ),
          // IconButton(
          //   icon: const Icon(Icons.countertops),
          //   onPressed: () {
          //     FirebaseFirestore.instance.collection("expenses").count().get().then(
          //           (res) => print(res.count),
          //           onError: (e) => print("Error completing: $e"),
          //         );
          //   },
          // ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "32,500 DH",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
          ),
          IconButton(
            color: AppColors.primary,
            icon: const Icon(Icons.add),
            onPressed: () {
              ExpenseBottomSheet.add(context);
            },
          ),
        ],
      ),
    );
  }
}
