import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  final String id;
  final String userId;
  final String type; // recurring, budget, custom, summary
  final String title;
  final String description;
  final DateTime scheduledTime;
  final bool isRepeating;
  final String? repeatInterval; // daily, weekly, monthly, yearly
  final DateTime? endDate;
  final bool isActive;
  final Map<String, dynamic> metadata; // Additional data based on type
  final DateTime createdAt;
  final DateTime updatedAt;

  Reminder({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.scheduledTime,
    required this.isRepeating,
    this.repeatInterval,
    this.endDate,
    required this.isActive,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reminder.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Reminder(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? 'custom',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      scheduledTime: (data['scheduledTime'] as Timestamp).toDate(),
      isRepeating: data['isRepeating'] ?? false,
      repeatInterval: data['repeatInterval'],
      endDate: data['endDate'] != null ? (data['endDate'] as Timestamp).toDate() : null,
      isActive: data['isActive'] ?? true,
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'description': description,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'isRepeating': isRepeating,
      'repeatInterval': repeatInterval,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'isActive': isActive,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

enum ReminderType {
  recurring,
  budget,
  custom,
  summary
}