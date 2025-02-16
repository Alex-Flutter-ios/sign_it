import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/features/subscription/data/subscription_service.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(this._service) : super(SubscriptionInitial());

  final SubscriptionService _service;

  SubscriptionService get service => _service;

  Future<void> checkSubscription() async {
    emit(SubscriptionLoading());
    try {
      final isPremium = _service.isPremiumUser();
      emit(SubscriptionLoaded(isPremium: isPremium));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> purchase(String packageId) async {
    emit(SubscriptionLoading());
    try {
      final success = await _service.purchasePackage(packageId);
      emit(success
          ? SubscriptionLoaded(isPremium: true)
          : SubscriptionError('Purchase failed'));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> restore() async {
    emit(SubscriptionLoading());
    try {
      final success = await _service.restorePurchases();
      emit(success
          ? SubscriptionLoaded(isPremium: true)
          : SubscriptionRestoreFailed('No subscriptions found'));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<String> getPaywallType() async {
    return await _service.getPaywallType();
  }

  bool isPremiumUser() {
    return _service.isPremiumUser();
  }
}
