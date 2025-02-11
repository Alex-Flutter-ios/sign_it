import 'subscription_service.dart';

class MockSubscriptionService implements SubscriptionService {
  bool _premium = false;
  bool _secondPayout = false;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _premium = false;
    _secondPayout = false;
  }

  @override
  Future<bool> isPremiumUser() async {
    return _premium;
  }

  @override
  Future<bool> purchasePackage(String packageId) async {
    await Future.delayed(const Duration(seconds: 2));
    _premium = true;
    return _premium;
  }

  @override
  Future<bool> restorePurchases() async {
    await Future.delayed(const Duration(seconds: 2));
    _premium = true;
    return _premium;
  }

  @override
  Future<String> getPaywallType() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _secondPayout ? 'b' : 'a';
  }
}
