import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/shared/components/cards/price_card.dart';
import 'package:expense_tracker/utils/formaters/formate_price.dart';
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
          children: [
            PriceCard(
              label: "Day",
              price: formatePrice(appState.dayAccumulation),
              border: selectedCard == "DAY",
              onPress: () => onCardPress("DAY"),
            ),
            const SizedBox(width: 8.0),
            PriceCard(
              label: "Week",
              price: formatePrice(appState.weekAccumulation),
              border: selectedCard == "WEEK",
              onPress: () => onCardPress("WEEK"),
            ),
            const SizedBox(width: 8.0),
            PriceCard(
              label: "Month",
              price: formatePrice(appState.monthAccumulation),
              border: selectedCard == "MONTH",
              onPress: () => onCardPress("MONTH"),
            ),
          ],
        ),
      ),
    );
  }
}
