import 'package:scaner_test_task/features/onboarding/data/models/onboarding_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final SharedPreferences _prefs;

  OnboardingRepository(this._prefs);

  Future<OnboardingModel> getOnboardingStatus() async {
    return OnboardingModel(
      isCompleted: _prefs.getBool('onboarding_completed') ?? false,
      ratingRequested: _prefs.getBool('rating_requested') ?? false,
    );
  }

  Future<void> completeOnboarding() async {
    await _prefs.setBool('onboarding_completed', true);
  }

  Future<void> setRatingRequested() async {
    await _prefs.setBool('rating_requested', true);
  }
}
