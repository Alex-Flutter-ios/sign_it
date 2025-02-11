import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/core/utils/routers/routes.dart';
import 'package:scaner_test_task/features/onboarding/data/onboarding_repository.dart';
// import 'package:scaner_test_task/features/documents_list/views/documents_screen.dart';
import 'package:scaner_test_task/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:scaner_test_task/features/splash/presentation/views/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => OnboardingRepository(prefs),
        ),
      ],
      child: BlocProvider<OnboardingCubit>(
        create: (context) => OnboardingCubit(
          context.read<OnboardingRepository>(),
        )..checkOnboardingStatus(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: const Color(0xFF2196F3),
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
      // key: GlobalKey(),
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: Routes.splash.name,
      routes: {
        Routes.splash.name: (context) => const SplashScreen(),
        Routes.onboarding.name: (context) => OnboardingScreen(),
        // Routes.documents.name: (context) => DocumentsScreen(),
        //  Routes.document.name: (context) => const DocumentScreen(),
        // Routes.paywallA.name: (context) => const PaywallAScreen(),
        // Routes.paywallB.name: (context) => const PaywallBScreen(),
        // Добавьте остальные роуты
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
