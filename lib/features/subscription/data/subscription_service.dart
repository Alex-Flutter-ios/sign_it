abstract class SubscriptionService {
  Future<void> initialize();
  Future<bool> isPremiumUser();
  Future<bool> purchasePackage(String packageId);
  Future<bool> restorePurchases();
  Future<String> getPaywallType();
}
