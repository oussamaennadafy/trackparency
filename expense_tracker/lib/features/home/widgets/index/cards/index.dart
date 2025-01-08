import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/enums/index.dart';
import 'package:expense_tracker/shared/components/cards/price_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cards extends StatefulWidget {
  const Cards({super.key});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  Future<void> onCardPress(DateFrame dateFrame) async {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    if (appState.selectedDateFrame == dateFrame) return;
    appState.setSelectedDateFrame = dateFrame;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Consumer<ApplicationState>(
        builder: (context, appState, _) => Row(
          spacing: 8.0,
          children: [
            PriceCard(
              label: "Today",
              price: appState.dayAccumulation.toString(),
              border: appState.selectedDateFrame == DateFrame.day,
              onPress: () => onCardPress(DateFrame.day),
            ),
            PriceCard(
              label: "This week",
              price: appState.weekAccumulation.toString(),
              border: appState.selectedDateFrame == DateFrame.week,
              onPress: () => onCardPress(DateFrame.week),
            ),
            PriceCard(
              label: "This Month",
              price: appState.monthAccumulation.toString(),
              border: appState.selectedDateFrame == DateFrame.month,
              onPress: () => onCardPress(DateFrame.month),
            ),
          ],
        ),
      ),
    );
  }
}
