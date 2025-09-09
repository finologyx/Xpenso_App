import 'subscription_service.dart';

class ProService {
  static final ProService _instance = ProService._();
  static ProService get instance => _instance;

  ProService._();

  // Check if user is Pro
  Future<bool> isProUser() async {
    return await SubscriptionService.instance.hasActiveSubscription();
  }

  // Upgrade user to Pro
  Future<void> upgradeToPro() async {
    await SubscriptionService.instance.upgradeToPro();
  }

  // Downgrade user from Pro
  Future<void> downgradeFromPro() async {
    await SubscriptionService.instance.downgradeFromPro();
  }
}