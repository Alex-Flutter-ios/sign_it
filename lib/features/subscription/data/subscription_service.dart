import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
    debugPrint('[StoreKitSubscriptionService] init() start');

    final available = await _iap.isAvailable();
    debugPrint('[StoreKitSubscriptionService] isAvailable -> $available');

    if (!available) {
      debugPrint(
          '[StoreKitSubscriptionService] Store is NOT available. Aborting init.');
      return;
    }

    // iOS Delegate
    if (Platform.isIOS) {
      debugPrint('[StoreKitSubscriptionService] Setting iOS delegate');
      final storeKit = InAppPurchaseStoreKitPlatformAddition();
      await storeKit.setDelegate(StoreKitDelegate());
    }

    // Подписываемся на поток покупок
    debugPrint('[StoreKitSubscriptionService] Listening to purchaseStream...');
    _purchaseSubscription = _iap.purchaseStream.listen((purchases) {
      debugPrint(
          '[StoreKitSubscriptionService] purchaseStream update -> $purchases');
      _cachedPurchases = purchases
          .where((p) =>
              p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored)
          .toList();
      debugPrint(
          '[StoreKitSubscriptionService] _cachedPurchases updated -> $_cachedPurchases');
    }, onError: (error) {
      debugPrint(
          '[StoreKitSubscriptionService] purchaseStream ERROR -> $error');
    });

    // Автоматически восстанавливаем покупки (для выявления уже купленных)
    debugPrint('[StoreKitSubscriptionService] Calling restorePurchases()...');
    await _iap.restorePurchases().timeout(
      Duration(seconds: 10),
      onTimeout: () {
        debugPrint('restorePurchases timed out');
        return;
      },
    );

    debugPrint(
        '[StoreKitSubscriptionService] init() complete, _cachedPurchases=$_cachedPurchases');
  }

  @override
  bool isPremiumUser() {
    final result = _cachedPurchases.isNotEmpty;
    debugPrint(
        '[StoreKitSubscriptionService] isPremiumUser -> $result, _cachedPurchases=$_cachedPurchases');
    return result;
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
              debugPrint('[StoreKit] purchase($productId) -> PURCHASED');
              // InAppPurchase.instance.completePurchase(purchase);
              completer.complete(true);
              subscription.cancel();
              break;
            // case PurchaseStatus.restored:
            //   debugPrint('[StoreKit] purchase($productId) -> RESTORED');
            //   InAppPurchase.instance.completePurchase(purchase);
            //   completer.complete(true);
            //   subscription.cancel();
            //   break;
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
  // @override
  // Future<bool> purchasePackage(String productId) async {
  //   debugPrint(
  //       '[StoreKitSubscriptionService] purchasePackage($productId) called');
  //   final completer = Completer<bool>();

  //   // Запрашиваем детали продукта
  //   final response = await _iap.queryProductDetails(Set.from({productId}));
  //   debugPrint(
  //       '[StoreKitSubscriptionService] queryProductDetails -> found ${response.productDetails.length} products, error=${response.error}');

  //   if (response.productDetails.isEmpty) {
  //     throw Exception('Product not found');
  //   }

  //   // Подписываемся отдельно, чтобы отследить результат именно для этого productId
  //   late StreamSubscription<List<PurchaseDetails>> subscription;
  //   subscription = _iap.purchaseStream.listen((purchases) {
  //     for (final purchase in purchases) {
  //       if (purchase.productID == productId) {
  //         switch (purchase.status) {
  //           case PurchaseStatus.purchased:
  //             debugPrint(
  //                 '[StoreKitSubscriptionService] purchasePackage($productId) -> PURCHASED');
  //             completer.complete(true);
  //             subscription.cancel();
  //             break;
  //           case PurchaseStatus.error:
  //             debugPrint(
  //                 '[StoreKitSubscriptionService] purchasePackage($productId) -> ERROR: ${purchase.error}');
  //             completer.completeError(purchase.error!);
  //             subscription.cancel();
  //             break;
  //           default:
  //             break;
  //         }
  //       }
  //     }
  //   });

  //   // Запускаем покупку
  //   debugPrint(
  //       '[StoreKitSubscriptionService] buyNonConsumable($productId) -> start');
  //   await _iap.buyNonConsumable(
  //     purchaseParam:
  //         PurchaseParam(productDetails: response.productDetails.first),
  //   );

  //   // Ждём результат из purchaseStream
  //   return completer.future.timeout(
  //     const Duration(seconds: 30),
  //     onTimeout: () {
  //       debugPrint(
  //           '[StoreKitSubscriptionService] purchasePackage($productId) -> TIMEOUT');
  //       throw TimeoutException('Purchase timed out');
  //     },
  //   );
  // }

  @override
  Future<bool> restorePurchases() async {
    debugPrint('[StoreKitSubscriptionService] restorePurchases() called');
    await _iap.restorePurchases().timeout(
      Duration(seconds: 10),
      onTimeout: () {
        debugPrint('restorePurchases timed out');
        return;
      },
    );

    await Future.delayed(const Duration(seconds: 2)); // ждём поток
    debugPrint(
        '[StoreKitSubscriptionService] after restore, _cachedPurchases=$_cachedPurchases');
    return _cachedPurchases.isNotEmpty;
  }

  @override
  Future<void> dispose() async {
    debugPrint('[StoreKitSubscriptionService] dispose() called');
    if (Platform.isIOS) {
      final iosPlatformAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(null);
    }
    await _purchaseSubscription?.cancel();
  }

  @override
  Future<String> getPaywallType() async {
    debugPrint('[StoreKitSubscriptionService] getPaywallType() start');
    final response = await _iap.queryProductDetails(_productIds.toSet());
    debugPrint(
        '[StoreKitSubscriptionService] ProductDetailsResponse ${response.productDetails}');
    final hasTrial = response.productDetails.any((p) => p.id == 'qr.trial.7');
    final result = hasTrial ? 'b' : 'a';
    debugPrint('[StoreKitSubscriptionService] getPaywallType -> $result');
    return result;
  }
}

// class StoreKitSubscriptionService implements SubscriptionService {
//   final InAppPurchase _iap = InAppPurchase.instance;
//   final List<String> _productIds = ['qr.trial.7', 'qr.notrial.5'];
//   List<PurchaseDetails> _cachedPurchases = [];
//   StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

//   @override
//   Future<void> init() async {
//     if (!(await _iap.isAvailable())) return;
//     if (Platform.isIOS) {
//       final storeKit = InAppPurchaseStoreKitPlatformAddition();
//       await storeKit.setDelegate(StoreKitDelegate());
//     }

//     _purchaseSubscription = _iap.purchaseStream.listen((purchases) {
//       _cachedPurchases = purchases
//           .where((p) =>
//               p.status == PurchaseStatus.purchased ||
//               p.status == PurchaseStatus.restored)
//           .toList();
//     });

//     await _iap.restorePurchases();
//   }

//   @override
//   bool isPremiumUser() {
//     return _cachedPurchases.isNotEmpty;
//   }

//   @override
//   Future<bool> purchasePackage(String productId) async {
//     final completer = Completer<bool>();

//     final response = await _iap.queryProductDetails(Set.from({productId}));
//     if (response.productDetails.isEmpty) {
//       throw Exception('Product not found');
//     }

//     late StreamSubscription<List<PurchaseDetails>> subscription;
//     subscription = _iap.purchaseStream.listen((purchases) {
//       for (final purchase in purchases) {
//         if (purchase.productID == productId) {
//           switch (purchase.status) {
//             case PurchaseStatus.purchased:
//               completer.complete(true);
//               subscription.cancel();
//               break;
//             case PurchaseStatus.error:
//               completer.completeError(purchase.error!);
//               subscription.cancel();
//               break;
//             default:
//               break;
//           }
//         }
//       }
//     });

//     await _iap.buyNonConsumable(
//       purchaseParam: PurchaseParam(
//         productDetails: response.productDetails.first,
//       ),
//     );

//     return completer.future.timeout(
//       const Duration(seconds: 30),
//       onTimeout: () => throw TimeoutException('Purchase timed out'),
//     );
//   }

//   @override
//   Future<bool> restorePurchases() async {
//     await _iap.restorePurchases();
//     await Future.delayed(const Duration(seconds: 2));
//     return _cachedPurchases.isNotEmpty;
//   }

//   @override
//   Future<void> dispose() async {
//     if (Platform.isIOS) {
//       final iosPlatformAddition =
//           _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(null);
//     }
//     _purchaseSubscription?.cancel();
//   }

//   @override
//   Future<String> getPaywallType() async {
//     final products = await _iap.queryProductDetails(_productIds.toSet());
//     final hasTrial = products.productDetails.any((p) => p.id == 'qr.trial.7');
//     return hasTrial ? 'b' : 'a';
//   }
// }
