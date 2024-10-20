import 'package:expense_tracker/shared/bottomSheets/add_expense_bottomSheet/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  Future<void> handleMenuPress() async {
    // TODO: handle menu press
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
