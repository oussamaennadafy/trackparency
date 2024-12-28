import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/shared/components/cards/price_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.onCardPress,
    required this.selectedCard,
  });

  final Function(String) onCardPress;
  final String selectedCard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Consumer<ApplicationState>(
        builder: (context, appState, _) => Row(
          spacing: 8.0,
          children: [
            PriceCard(
              label: "Day",
              price: appState.dayAccumulation.toString(),
              border: selectedCard == "DAY",
              onPress: () => onCardPress("DAY"),
            ),
            PriceCard(
              label: "Week",
              price: appState.weekAccumulation.toString(),
              border: selectedCard == "WEEK",
              onPress: () => onCardPress("WEEK"),
            ),
            PriceCard(
              label: "Month",
              price: appState.monthAccumulation.toString(),
              border: selectedCard == "MONTH",
              onPress: () => onCardPress("MONTH"),
            ),
          ],
        ),
      ),
    );
  }
}
