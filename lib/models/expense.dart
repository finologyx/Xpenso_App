import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final String currency;
  final String category;
  final String paymentMethod;
  final String notes;
  final List<String> tags;
  final DateTime date;
  final String receiptUrl;
  final bool isRecurring;
  final String? recurringTemplateId;
  final String? recurringType;
  final int? recurringInterval;
  final String? sharedAccountId;
  final String? paidByUserId;
  final List<String>? splitWithUserIds;

  Expense({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.currency,
    required this.category,
    required this.paymentMethod,
    required this.notes,
    required this.tags,
    required this.date,
    required this.receiptUrl,
    required this.isRecurring,
    this.recurringTemplateId,
    this.recurringType,
    this.recurringInterval,
    this.sharedAccountId,
    this.paidByUserId,
    this.splitWithUserIds,
  });

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      amount: data['amount'] ?? 0.0,
      currency: data['currency'] ?? 'USD',
      category: data['category'] ?? 'Other',
      paymentMethod: data['paymentMethod'] ?? 'Cash',
      notes: data['notes'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      date: (data['date'] as Timestamp).toDate(),
      receiptUrl: data['receiptUrl'] ?? '',
      isRecurring: data['isRecurring'] ?? false,
      recurringTemplateId: data['recurringTemplateId'],
      recurringType: data['recurringType'],
      recurringInterval: data['recurringInterval'],
      sharedAccountId: data['sharedAccountId'],
      paidByUserId: data['paidByUserId'],
      splitWithUserIds: List<String>.from(data['splitWithUserIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amount': amount,
      'currency': currency,
      'category': category,
      'paymentMethod': paymentMethod,
      'notes': notes,
      'tags': tags,
      'date': Timestamp.fromDate(date),
      'receiptUrl': receiptUrl,
      'isRecurring': isRecurring,
      'recurringTemplateId': recurringTemplateId,
      'recurringType': recurringType,
      'recurringInterval': recurringInterval,
      'sharedAccountId': sharedAccountId,
      'paidByUserId': paidByUserId,
      'splitWithUserIds': splitWithUserIds,
    };
  }
}