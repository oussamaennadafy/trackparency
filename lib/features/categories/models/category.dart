import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final String userId;
  final String? color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.userId,
    this.color,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] as String,
      icon: data['icon'] as String,
      userId: data['userId'] as String,
      color: data['color'] as String?,
    );
  }
}
