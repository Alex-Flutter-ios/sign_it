// States
part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingShow extends OnboardingState {
  OnboardingShow({required this.firstTime});
  final bool firstTime;
}

final class OnboardingCompleted extends OnboardingState {}
