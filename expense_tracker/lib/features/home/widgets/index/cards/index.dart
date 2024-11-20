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
              onPress: () => {
                // print((333 / (appState.monthAccumulation != 0 ? appState.monthAccumulation : 1)) * 100)
                print((90 / (90 != 0 ? 90 : 1)) * 100)
              },
            ),
            const SizedBox(width: 8.0),
            PriceCard(
              label: "Week",
              price: appState.weekAccumulation.toString(),
              onPress: () => {
                // print((333 / (appState.monthAccumulation != 0 ? appState.monthAccumulation : 1)) * 100)
                print((0 / (0 != 0 ? 0 : 1)) * 100)
              },
            ),
            const SizedBox(width: 8.0),
            PriceCard(
              label: "Month",
              price: appState.monthAccumulation.toString(),
              onPress: () => {
                // print((1 / (appState.monthAccumulation != 0 ? appState.monthAccumulation : 1)) * 100)
                print((0 / (0 != 0 ? 0 : 1)) * 100)
              },
            ),
          ],
        ),
      ),
    );
  }
}
