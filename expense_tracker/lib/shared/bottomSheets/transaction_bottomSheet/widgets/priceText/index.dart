import 'package:expense_tracker/shared/components/texts/shake_text.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/utils/formaters/formate_price.dart';
import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.isPriceInvalid,
    required this.price,
  });

  final String price;
  final bool isPriceInvalid;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: isPriceInvalid
                ? ShakeWidget(
                    child: Text(
                      "DH",
                      style: TextStyle(
                        fontSize: 28,
                        color: isPriceInvalid ? Colors.red.shade400 : AppColors.gray,
                      ),
                    ),
                  )
                : Text(
                    "DH",
                    style: TextStyle(
                      fontSize: 28,
                      color: isPriceInvalid ? Colors.red.shade400 : AppColors.gray,
                    ),
                  ),
          ),
          const SizedBox(width: 4),
          isPriceInvalid
              ? ShakeWidget(
                  child: Text(
                    price,
                    style: TextStyle(
                      fontSize: 54,
                      color: isPriceInvalid ? Colors.red : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Text(
                  price.contains("+") ? price : formatePrice(int.parse(price)),
                  style: TextStyle(
                    fontSize: 54,
                    color: isPriceInvalid ? Colors.red : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}
