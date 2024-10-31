import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/shared/components/cards/price_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Consumer<ApplicationState>(
        builder: (context, appState, _) => Row(
          children: [
            PriceCard(
              label: "Day",
              price: appState.dayAccumulation.toString(),
              border: true,
            ),
            const SizedBox(width: 8.0),
            PriceCard(
              label: "Week",
              price: appState.weekAccumulation.toString(),
            ),
            const SizedBox(width: 8.0),
            PriceCard(
              label: "Month",
              price: appState.monthAccumulation.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
