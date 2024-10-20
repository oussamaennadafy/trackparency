import 'package:flutter/material.dart';

class DateTitle extends StatelessWidget {
  const DateTitle({
    super.key,
    required this.date,
    required this.totalPrice,
  });

  final String date;
  final String totalPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date),
        Text(totalPrice),
      ],
    );
  }
}
