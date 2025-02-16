import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scaner_test_task/core/utils/routers/routes.dart';
import 'package:scaner_test_task/features/documents/presentation/views/document_info_screen.dart';
import 'package:scaner_test_task/features/documents/presentation/views/documents_screen.dart';
import 'package:scaner_test_task/features/onboarding/data/onboarding_repository.dart';
import 'package:scaner_test_task/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:scaner_test_task/features/splash/presentation/views/splash_screen.dart';
import 'package:scaner_test_task/features/subscription/data/subscription_service.dart';
import 'package:scaner_test_task/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:scaner_test_task/features/subscription/presentation/views/paywall_a_screen.dart';
import 'package:scaner_test_task/features/subscription/presentation/views/subscription_router_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/adapters/document_adapter.dart';
import 'features/documents/data/datasource/local_datasource.dart';
import 'features/documents/data/datasource/remote_datasource.dart';
import 'features/documents/data/document_repository_impl.dart';
import 'features/documents/data/models/document.dart';
import 'features/documents/presentation/cubit/documents_cubit.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //date formatting initialization
  await initializeDateFormatting();

  //hive initialization
  await Hive.initFlutter();
  Hive.registerAdapter(DocumentAdapter());
  final box = await Hive.openBox<Document>('documents');
  box.clear();

  //shared preferences initialization
  final prefs = await SharedPreferences.getInstance();

  //subscription initialization
  // final subscriptionService = MockSubscriptionService();
  // await subscriptionService.init();

  //scanbot sdk initialization
  final licenseKey = "bORqy5cafPI7fknl/ShLtRFyu7v+bm" +
      "cC7dEqs06AHT/RNJbB3WlUmsolxPR0" +
      "Qy0hHivuPsqzLJQL0ZFrFeH23w6dRL" +
      "y/S9e6UvAIlB9dOWe/Ei55xKSl+Cf2" +
      "59pMVKZ+o+z8EAR04XtH29WISzydzv" +
      "EHYpT/Oe4VdCX02Jm9qul0COJ87oRd" +
      "fRxYZ/IXNMMvk4K2tKfjDkWsA6Go6T" +
      "bZ4BxUJ/zrLBts4+A4hBsTbOTdGlI1" +
      "OAB1pSaRvw8fOWt/hV8FGUyblxi0D/" +
      "uFDyz4jHaGFwRqPQVgRL6jr5QdbAlB" +
      "JJ1vQQS8Flw1xtmBaxQpMgDQh1/llB" +
      "onv44mIZ6DNw==\nU2NhbmJvdFNESw" +
      "pjb20uZXhhbXBsZS5zY2FuZXJfdGVz" +
      "dF90YXNrCjE3NDAwOTU5OTkKODM4OD" +
      "YwNwoxOQ==\n"; //7 days trial license key
  ScanbotSdk.initScanbotSdk(
    ScanbotSdkConfig(loggingEnabled: true, licenseKey: licenseKey),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => OnboardingRepository(prefs),
        ),
        RepositoryProvider<SubscriptionService>(
          create: (_) => StoreKitSubscriptionService()..init(),
        ),
        RepositoryProvider(
          create: (_) => DocumentLocalDataSource(box),
        ),
        RepositoryProvider(
          create: (_) => DocumentRemoteDataSource(Dio()),
        ),
        RepositoryProvider(
          create: (context) => DocumentRepository(
            localDataSource: context.read<DocumentLocalDataSource>(),
            remoteDataSource: context.read<DocumentRemoteDataSource>(),
          ),
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
          BlocProvider<DocumentsCubit>(
            create: (context) => DocumentsCubit(
              context.read<DocumentRepository>(),
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
          elevation: 0,
          backgroundColor: Color(0xFFF2F4FF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F4FF),
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
        Routes.paywallA.name: (context) => const PaywallScreen(),
        Routes.documents.name: (context) => const DocumentsScreen(),
        Routes.documentInfo.name: (context) => const DocumentInfoScreen(),
      },
    );
  }
}
