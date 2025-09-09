import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String userId;
  final String content;
  final bool isUserMessage;
  final DateTime timestamp;
  final ChatMessageType type;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.content,
    required this.isUserMessage,
    required this.timestamp,
    required this.type,
    this.metadata,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      isUserMessage: data['isUserMessage'] ?? false,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: _chatMessageTypeFromString(data['type'] ?? 'text'),
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'isUserMessage': isUserMessage,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': _chatMessageTypeToString(type),
      'metadata': metadata,
    };
  }

  static ChatMessageType _chatMessageTypeFromString(String type) {
    switch (type) {
      case 'text':
        return ChatMessageType.text;
      case 'budgetTip':
        return ChatMessageType.budgetTip;
      case 'expensePrediction':
        return ChatMessageType.expensePrediction;
      case 'savingsRecommendation':
        return ChatMessageType.savingsRecommendation;
      case 'categoryInsight':
        return ChatMessageType.categoryInsight;
      default:
        return ChatMessageType.text;
    }
  }

  static String _chatMessageTypeToString(ChatMessageType type) {
    switch (type) {
      case ChatMessageType.text:
        return 'text';
      case ChatMessageType.budgetTip:
        return 'budgetTip';
      case ChatMessageType.expensePrediction:
        return 'expensePrediction';
      case ChatMessageType.savingsRecommendation:
        return 'savingsRecommendation';
      case ChatMessageType.categoryInsight:
        return 'categoryInsight';
    }
  }
}

enum ChatMessageType {
  text,
  budgetTip,
  expensePrediction,
  savingsRecommendation,
  categoryInsight
}