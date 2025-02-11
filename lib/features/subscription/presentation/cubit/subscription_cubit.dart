// features/subscription/presentation/cubit/subscription_cubit.dart
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
      final isPremium = await _service.isPremiumUser();
      emit(SubscriptionLoaded(isPremium: isPremium));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> purchase(String packageId) async {
    emit(SubscriptionLoading());
    try {
      final success = await _service.purchasePackage(packageId);
      emit(SubscriptionLoaded(isPremium: success));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> restore() async {
    emit(SubscriptionLoading());
    try {
      final success = await _service.restorePurchases();
      emit(SubscriptionLoaded(isPremium: success));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<String> getPaywallType() async {
    return await _service.getPaywallType();
  }
}
