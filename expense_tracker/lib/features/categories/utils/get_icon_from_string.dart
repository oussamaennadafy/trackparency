import 'package:flutter/material.dart';

IconData? getIconFromString(String iconName) {
  switch (iconName) {
    case 'arrow_downward':
      return Icons.arrow_downward;
    case 'arrow_upward':
      return Icons.arrow_upward;
    case 'directions_car':
      return Icons.directions_car;
    case 'shopping_cart':
      return Icons.shopping_cart;
    case 'restaurant':
      return Icons.restaurant;
    default:
      return Icons.shopping_bag;
  }
}
