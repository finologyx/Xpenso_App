import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final bool isCustom;
  final String? userId;
  final DateTime createdAt;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.isCustom,
    this.userId,
    required this.createdAt,
    required this.color,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      icon: data['icon'] ?? '💰',
      isCustom: data['isCustom'] ?? false,
      userId: data['userId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      color: data['color'] ?? '#FF5722',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'isCustom': isCustom,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'color': color,
    };
  }
}