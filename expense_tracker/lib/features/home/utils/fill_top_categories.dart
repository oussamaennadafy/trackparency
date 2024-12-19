import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/features/categories/models/selected_category.dart';
import 'package:expense_tracker/features/home/models/top_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void fillTopCategories(BuildContext context, List<SelectedCategory> selectedCategories) {
  final appState = Provider.of<ApplicationState>(context, listen: false);
  final List<TopCategory> emptyCategories = [];
  for (var i = 0; i < 3; i++) {
    final selectedCategory = selectedCategories[i];
    emptyCategories.add(
      TopCategory(
        icon: selectedCategory.icon,
        name: selectedCategory.name,
        color: selectedCategory.color,
        percentage: 0,
        total: 0,
      ),
    );
  }
  appState.setTopThreeSpendingCategories = emptyCategories;
}
