import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:scaner_test_task/features/documents_list/views/documents_screen.dart';
import 'package:scaner_test_task/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:scaner_test_task/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:scaner_test_task/features/splash/presentation/views/splash_screen.dart';
// import 'package:scaner_test_task/features/document/views/document_screen.dart';
// import 'package:scaner_test_task/features/documents_list/views/documents_list_screen.dart';
// import 'package:scaner_test_task/features/subscription/views/paywall_a_screen.dart';
// import 'package:scaner_test_task/features/subscription/views/paywall_b_screen.dart';
// import 'package:scaner_test_task/core/views/splash_screen.dart';

import 'routes.dart';

class AppRouter {
  static Map<String, Widget Function(BuildContext)> get routes => {
        Routes.splash.name: (context) => const SplashScreen(),
        Routes.onboarding.name: (context) => OnboardingScreen(),
        // Routes.subscription.name: (context) => const PaywallAScreen(),
        // Routes.documents.name: (context) => const DocumentsScreen(),
        // Routes.document.name: (context) => const DocumentScreen(),
        // Routes.paywallA.name: (context) => const PaywallAScreen(),
        // Routes.paywallB.name: (context) => const PaywallBScreen(),
      };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const RootNavigator(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}

class RootNavigator extends StatelessWidget {
  const RootNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingCompleted) {
          // return const DocumentsScreen();
        }
        return OnboardingScreen();
      },
    );
  }
}
