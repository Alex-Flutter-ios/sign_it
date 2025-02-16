import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/features/subscription/data/subscription_service.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(this._service) : super(SubscriptionInitial());

  final SubscriptionService _service;

  SubscriptionService get service => _service;

  Future<void> checkSubscription() async {
    try {
      emit(SubscriptionLoading());
      debugPrint('[SubscriptionCubit] checkSubscription -> init service...');
      await _service.init();

      final isPremium = _service.isPremiumUser();
      debugPrint(
          '[SubscriptionCubit] checkSubscription -> isPremium=$isPremium');
      emit(SubscriptionLoaded(isPremium: isPremium));
    } catch (e) {
      debugPrint('[SubscriptionCubit] checkSubscription error: $e');
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> purchase(String packageId) async {
    emit(SubscriptionLoading());
    try {
      debugPrint('[SubscriptionCubit] purchase($packageId) start');
      final success = await _service.purchasePackage(packageId);
      debugPrint(
          '[SubscriptionCubit] purchase($packageId) -> success=$success');
      if (success) {
        emit(SubscriptionLoaded(isPremium: true));
      } else {
        emit(SubscriptionError('Purchase failed'));
      }
    } catch (e) {
      debugPrint('[SubscriptionCubit] purchase($packageId) -> error: $e');
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> restore() async {
    emit(SubscriptionLoading());
    try {
      debugPrint('[SubscriptionCubit] restore() start');
      final success = await _service.restorePurchases();
      debugPrint('[SubscriptionCubit] restore() -> success=$success');
      if (success) {
        emit(SubscriptionLoaded(isPremium: true));
      } else {
        emit(SubscriptionRestoreFailed('No subscriptions found'));
      }
    } catch (e) {
      debugPrint('[SubscriptionCubit] restore() -> error: $e');
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<String> getPaywallType() async {
    debugPrint('[SubscriptionCubit] getPaywallType()');
    return _service.getPaywallType();
  }

  bool isPremiumUser() {
    final premium = _service.isPremiumUser();
    debugPrint('[SubscriptionCubit] isPremiumUser() -> $premium');
    return premium;
  }
}
