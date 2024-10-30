import 'package:expense_tracker/features/categories/models/category.dart';

class SelectedCategory {
  final String id;
  final String name;
  final String icon;
  final String userId;
  final String? color;

  SelectedCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.userId,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'userId': userId,
      'color': color,
    };
  }

  factory SelectedCategory.fromMap(Map<String, dynamic> map) {
    return SelectedCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String,
      userId: map['userId'] as String,
      color: map['color'] as String?,
    );
  }

  factory SelectedCategory.fromCategory(Category category) {
    return SelectedCategory(
      id: category.id,
      name: category.name,
      icon: category.icon,
      userId: category.userId,
      color: category.color,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SelectedCategory && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
