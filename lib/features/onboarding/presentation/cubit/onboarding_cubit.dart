import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:scaner_test_task/features/onboarding/data/onboarding_repository.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._repository) : super(OnboardingInitial());

  final OnboardingRepository _repository;

  Future<void> checkOnboardingStatus() async {
    final status = await _repository.getOnboardingStatus();
    if (!status.isCompleted) {
      emit(OnboardingShow(firstTime: true));
    } else if (!status.ratingRequested) {
      emit(OnboardingShow(firstTime: false));
    } else {
      emit(OnboardingCompleted());
    }
  }

  Future<void> completeOnboarding(bool firstTime) async {
    if (firstTime) {
      await _repository.completeOnboarding();
    }
    await _repository.setRatingRequested();
    emit(OnboardingCompleted());
  }
}
