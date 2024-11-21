import 'package:flutter/material.dart';

IconData? getIconFromString(String iconName) {
  switch (iconName) {
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'restaurant':
      return Icons.restaurant;
    case 'directions_car':
      return Icons.directions_car;
    case 'home':
      return Icons.home;
    case 'sports_basketball':
      return Icons.sports_basketball;
    case 'flight':
      return Icons.flight;
    case 'school':
      return Icons.school;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'receipt_long':
      return Icons.receipt_long;
    case 'checkroom':
      return Icons.checkroom;
    case 'movie':
      return Icons.movie;
    case 'pets':
      return Icons.pets;
    case 'train_rounded':
      return Icons.train_rounded;
    case 'chair':
      return Icons.chair;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'shopping_cart':
      return Icons.shopping_cart;
    case 'arrow_downward':
      return Icons.arrow_downward;
    case 'arrow_upward':
      return Icons.arrow_upward;
    default:
      return Icons.shopping_bag;
  }
}
