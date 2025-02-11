import 'dart:async';

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        Timer(const Duration(seconds: 2), () {
          context.read<OnboardingCubit>().checkOnboardingStatus();
          if (state is OnboardingShow) {
            Navigator.pushReplacementNamed(context, Routes.onboarding.name);
          } else if (state is OnboardingCompleted) {
            Navigator.pushReplacementNamed(context, Routes.subscription.name);
          }
        });
      },
      child: Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/animations/loader.json',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
