import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

abstract class SubscriptionService {
  Future<void> init();
  Future<void> dispose();
  bool isPremiumUser();
  Future<bool> purchasePackage(String packageId);
  Future<bool> restorePurchases();
  Future<String> getPaywallType();
}

class StoreKitDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, _) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() => false;
}

class StoreKitSubscriptionService implements SubscriptionService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> _productIds = ['qr.trial.7', 'qr.notrial.5'];
  List<PurchaseDetails> _cachedPurchases = [];
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  @override
  Future<void> init() async {
    if (!(await _iap.isAvailable())) return;
    if (Platform.isIOS) {
      final storeKit = InAppPurchaseStoreKitPlatformAddition();
      await storeKit.setDelegate(StoreKitDelegate());
    }

    _purchaseSubscription = _iap.purchaseStream.listen((purchases) {
      _cachedPurchases = purchases
          .where((p) =>
              p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored)
          .toList();
    });

    await _iap.restorePurchases();
  }

  @override
  bool isPremiumUser() {
    return _cachedPurchases.isNotEmpty;
  }

  @override
  Future<bool> purchasePackage(String productId) async {
    final completer = Completer<bool>();

    final response = await _iap.queryProductDetails(Set.from({productId}));
    if (response.productDetails.isEmpty) {
      throw Exception('Product not found');
    }

    late StreamSubscription<List<PurchaseDetails>> subscription;
    subscription = _iap.purchaseStream.listen((purchases) {
      for (final purchase in purchases) {
        if (purchase.productID == productId) {
          switch (purchase.status) {
            case PurchaseStatus.purchased:
              completer.complete(true);
              subscription.cancel();
              break;
            case PurchaseStatus.error:
              completer.completeError(purchase.error!);
              subscription.cancel();
              break;
            default:
              break;
          }
        }
      }
    });

    await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(
        productDetails: response.productDetails.first,
      ),
    );

    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw TimeoutException('Purchase timed out'),
    );
  }

  @override
  Future<bool> restorePurchases() async {
    await _iap.restorePurchases();
    await Future.delayed(const Duration(seconds: 2));
    return _cachedPurchases.isNotEmpty;
  }

  @override
  Future<void> dispose() async {
    if (Platform.isIOS) {
      final iosPlatformAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(null);
    }
    _purchaseSubscription?.cancel();
  }

  @override
  Future<String> getPaywallType() async {
    final products = await _iap.queryProductDetails(_productIds.toSet());
    final hasTrial = products.productDetails.any((p) => p.id == 'qr.trial.7');
    return hasTrial ? 'b' : 'a';
  }
}
