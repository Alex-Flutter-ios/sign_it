// features/subscription/presentation/cubit/subscription_state.dart
part of 'subscription_cubit.dart';

@immutable
sealed class SubscriptionState {}

final class SubscriptionInitial extends SubscriptionState {}

final class SubscriptionLoading extends SubscriptionState {}

final class SubscriptionLoaded extends SubscriptionState {
  SubscriptionLoaded({required this.isPremium});
  final bool isPremium;
}

final class SubscriptionError extends SubscriptionState {
  SubscriptionError(this.message);
  final String message;
}

final class SubscriptionRestoreFailed extends SubscriptionState {
  SubscriptionRestoreFailed(this.message);
  final String message;
}
