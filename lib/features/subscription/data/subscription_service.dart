import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class SubscriptionService {
  Future<void> init();
  bool isPremiumUser();
  Future<bool> purchasePackage(String packageId);
  Future<bool> restorePurchases();
  Future<String> getPaywallType();
}

class StoreKitSubscriptionService implements SubscriptionService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> _productIds = ['qr.trial.7', 'qr.notrial.5'];
  List<PurchaseDetails> _cachedPurchases = [];
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  // 1. Инициализация с подпиской на поток покупок
  @override
  Future<void> init() async {
    _purchaseSubscription = _iap.purchaseStream.listen((purchases) {
      _cachedPurchases = purchases
          .where((p) =>
              p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored)
          .toList();

      // Автозавершение покупок для Android
      for (final purchase in purchases) {
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    });

    // Первоначальная загрузка покупок
    await _iap.restorePurchases();
  }

  // 2. Проверка премиум-статуса
  @override
  bool isPremiumUser() {
    return _cachedPurchases.isNotEmpty;
  }

  // 3. Покупка пакета с обработкой потока
  @override
  Future<bool> purchasePackage(String productId) async {
    final completer = Completer<bool>();

    // Загрузка информации о продукте
    final response = await _iap.queryProductDetails(Set.from({productId}));
    if (response.productDetails.isEmpty) {
      throw Exception('Product not found');
    }

    // Временная подписка на поток покупок
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

    // Инициирование покупки
    await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(
        productDetails: response.productDetails.first,
        applicationUserName: null,
      ),
    );

    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw TimeoutException('Purchase timed out'),
    );
  }

  // 4. Восстановление покупок с обновлением кеша
  @override
  Future<bool> restorePurchases() async {
    await _iap.restorePurchases();
    await Future.delayed(const Duration(seconds: 2));
    return _cachedPurchases.isNotEmpty;
  }

  // 5. Метод для очистки ресурсов
  void dispose() {
    _purchaseSubscription?.cancel();
  }

  // 6. Получение типа Paywall из метаданных
  @override
  Future<String> getPaywallType() async {
    final products = await _iap.queryProductDetails(_productIds.toSet());
    final hasTrial = products.productDetails.any((p) => p.id == 'qr.trial.7');
    return hasTrial ? 'b' : 'a';
  }
}
