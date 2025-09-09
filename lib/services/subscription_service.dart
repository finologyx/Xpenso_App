import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._();
  static SubscriptionService get instance => _instance;

  SubscriptionService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if user has an active subscription
  Future<bool> hasActiveSubscription() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          bool isPro = userData['isPro'] ?? false;
          if (isPro && userData.containsKey('subscriptionExpiry')) {
            Timestamp? expiry = userData['subscriptionExpiry'];
            if (expiry != null) {
              return expiry.toDate().isAfter(DateTime.now());
            }
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Upgrade user to Pro subscription
  Future<void> upgradeToPro() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'isPro': true,
        'subscriptionExpiry': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)), // 30 days from now
        ),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Downgrade user from Pro subscription
  Future<void> downgradeFromPro() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'isPro': false,
        'subscriptionExpiry': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Extend subscription (for renewal)
  Future<void> extendSubscription(int days) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          DateTime currentExpiry = DateTime.now();
          if (userData.containsKey('subscriptionExpiry')) {
            Timestamp? expiry = userData['subscriptionExpiry'];
            if (expiry != null) {
              currentExpiry = expiry.toDate();
            }
          }

          await _firestore.collection('users').doc(user.uid).update({
            'subscriptionExpiry': Timestamp.fromDate(
              currentExpiry.add(Duration(days: days)),
            ),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}