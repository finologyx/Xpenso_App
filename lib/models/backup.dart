import 'package:cloud_firestore/cloud_firestore.dart';

class Backup {
  final String id;
  final String userId;
  final String fileName;
  final String storagePath;
  final int fileSize;
  final DateTime timestamp;
  final String deviceInfo;
  final String appVersion;
  final bool isAutomatic;

  Backup({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.storagePath,
    required this.fileSize,
    required this.timestamp,
    required this.deviceInfo,
    required this.appVersion,
    required this.isAutomatic,
  });

  factory Backup.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Backup(
      id: doc.id,
      userId: data['userId'] ?? '',
      fileName: data['fileName'] ?? '',
      storagePath: data['storagePath'] ?? '',
      fileSize: data['fileSize'] ?? 0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      deviceInfo: data['deviceInfo'] ?? 'Unknown',
      appVersion: data['appVersion'] ?? '1.0.0',
      isAutomatic: data['isAutomatic'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'fileName': fileName,
      'storagePath': storagePath,
      'fileSize': fileSize,
      'timestamp': Timestamp.fromDate(timestamp),
      'deviceInfo': deviceInfo,
      'appVersion': appVersion,
      'isAutomatic': isAutomatic,
    };
  }
}