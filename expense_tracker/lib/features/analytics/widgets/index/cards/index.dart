import 'package:expense_tracker/shared/components/cards/price_card.dart';
import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Row(
        children: [
          PriceCard(
            label: "Day",
            price: "52",
            border: true,
          ),
          SizedBox(width: 8.0),
          PriceCard(
            label: "Week",
            price: "403",
          ),
          SizedBox(width: 8.0),
          PriceCard(
            label: "Month",
            price: "1,612",
          ),
        ],
      ),
    );
  }
}
