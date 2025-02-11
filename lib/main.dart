import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/core/utils/routers/routes.dart';
import 'package:scaner_test_task/features/onboarding/data/onboarding_repository.dart';
import 'package:scaner_test_task/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:scaner_test_task/features/splash/presentation/views/splash_screen.dart';
import 'package:scaner_test_task/features/subscription/data/mock_subscription_service_impl.dart';
import 'package:scaner_test_task/features/subscription/data/subscription_service.dart';
import 'package:scaner_test_task/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:scaner_test_task/features/subscription/presentation/views/paywall_a_screen.dart';
import 'package:scaner_test_task/features/subscription/presentation/views/paywall_b_screen.dart';
import 'package:scaner_test_task/features/subscription/presentation/views/subscription_router_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final subscriptionService = MockSubscriptionService();
  await subscriptionService.initialize();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => OnboardingRepository(prefs),
        ),
        RepositoryProvider<SubscriptionService>(
          create: (_) => subscriptionService,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OnboardingCubit>(
            create: (context) => OnboardingCubit(
              context.read<OnboardingRepository>(),
            )..checkOnboardingStatus(),
          ),
          BlocProvider<SubscriptionCubit>(
            create: (context) => SubscriptionCubit(
              context.read<SubscriptionService>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5436FF),
          primary: const Color(0xFF364EFF),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalKey<NavigatorState>(),
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: Routes.splash.name,
      routes: {
        Routes.splash.name: (context) => const SplashScreen(),
        Routes.onboarding.name: (context) => OnboardingScreen(),
        Routes.subscription.name: (context) => const SubscriptionRouterScreen(),
        Routes.paywallA.name: (context) => const PaywallAScreen(),
        Routes.paywallB.name: (context) => const PaywallBScreen(),
        // Routes.documents.name: (context) => DocumentsScreen(),
        //  Routes.document.name: (context) => const DocumentScreen(),
      },
      // home: BlocListener<OnboardingCubit, OnboardingState>(
      //   listener: (context, state) {
      //     if (state is OnboardingCompleted) {
      //       // Переход на следующий экран после завершения онбординга
      //       Navigator.pushReplacementNamed(context, Routes.subscription.name);
      //     }
      //   },
      //   child: const SplashScreen(),
      // ),
    );
  }
}
