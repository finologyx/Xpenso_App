import 'package:cloud_firestore/cloud_firestore.dart';

class SharedAccount {
  final String id;
  final String name;
  final String ownerId;
  final List<String> memberIds;
  final Map<String, String> userRoles; // Map of userId to role
  final DateTime createdAt;
  final DateTime updatedAt;

  SharedAccount({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.memberIds,
    required this.userRoles,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SharedAccount.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SharedAccount(
      id: doc.id,
      name: data['name'] ?? '',
      ownerId: data['ownerId'] ?? '',
      memberIds: List<String>.from(data['memberIds'] ?? []),
      userRoles: Map<String, String>.from(data['userRoles'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'memberIds': memberIds,
      'userRoles': userRoles,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

enum SharedAccountRole {
  owner,
  admin,
  member
}