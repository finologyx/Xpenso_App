import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final String id;
  final String userId;
  final String category;
  final double amount;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;
  final bool isRecurring;
  final String? sharedAccountId;

  Budget({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.spent,
    required this.startDate,
    required this.endDate,
    required this.isRecurring,
    this.sharedAccountId,
  });

  factory Budget.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Budget(
      id: doc.id,
      userId: data['userId'] ?? '',
      category: data['category'] ?? 'Overall',
      amount: data['amount'] ?? 0.0,
      spent: data['spent'] ?? 0.0,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      isRecurring: data['isRecurring'] ?? false,
      sharedAccountId: data['sharedAccountId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'amount': amount,
      'spent': spent,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'isRecurring': isRecurring,
      'sharedAccountId': sharedAccountId,
    };
  }
}