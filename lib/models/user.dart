import 'package:cloud_firestore/cloud_firestore.dart';

class XpensoUser {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final bool isPro;
  final DateTime? subscriptionExpiry;
  final DateTime createdAt;
  final bool isActive;
  final DateTime lastLoginAt;

  XpensoUser({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.isPro,
    this.subscriptionExpiry,
    required this.createdAt,
    required this.isActive,
    required this.lastLoginAt,
  });

  factory XpensoUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return XpensoUser(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'],
      isPro: data['isPro'] ?? false,
      subscriptionExpiry: data['subscriptionExpiry'] != null
          ? (data['subscriptionExpiry'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      lastLoginAt: (data['lastLoginAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'isPro': isPro,
      'subscriptionExpiry': subscriptionExpiry != null
          ? Timestamp.fromDate(subscriptionExpiry!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }
}