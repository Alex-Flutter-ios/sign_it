import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:scaner_test_task/core/utils/routers/routes.dart';
import 'package:scaner_test_task/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Инициализация необходимых сервисов
    // await context.read<SubscriptionCubit>().initialize();
    await context.read<OnboardingCubit>().checkOnboardingStatus();

    if (mounted) {
      final isOnboardingCompleted =
          context.read<OnboardingCubit>().state is OnboardingCompleted;

      Navigator.pushReplacementNamed(
          context,
          isOnboardingCompleted
              ? Routes.documents.name
              : Routes.onboarding.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/splash.json',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
