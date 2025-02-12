import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/core/utils/routers/routes.dart';
import '../cubit/subscription_cubit.dart';
import 'paywall_a_screen.dart';
import 'paywall_b_screen.dart';

class SubscriptionRouterScreen extends StatefulWidget {
  const SubscriptionRouterScreen({super.key});

  @override
  State<SubscriptionRouterScreen> createState() =>
      _SubscriptionRouterScreenState();
}

class _SubscriptionRouterScreenState extends State<SubscriptionRouterScreen> {
  bool? isPremium;
  String? paywallType;
  late SubscriptionCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SubscriptionCubit>(context);

    _initSubscriptionFlow();
  }

  Future<void> _initSubscriptionFlow() async {
    final subscriptionCubit = context.read<SubscriptionCubit>();

    // 1) Проверяем, есть ли подписка
    await subscriptionCubit.checkSubscription();
    final currentState = subscriptionCubit.state;
    if (currentState is SubscriptionLoaded && currentState.isPremium) {
      // Если пользователь уже премиум, сразу уходим дальше (например, на DocumentsScreen)
      setState(() => isPremium = true);
      return;
    }

    // 2) Если не премиум — узнаём тип Paywall
    final type = await subscriptionCubit.getPaywallType();
    setState(() {
      isPremium = false;
      paywallType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isPremium == null && paywallType == null) {
      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }

    if (isPremium == true) {
      // Переходим на экран документов (или любой другой) и не рисуем Paywall
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, Routes.documents.name);
      });
      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }
    return PaywallAScreen(paywallType: paywallType ?? '');
    // return paywallType == 'b'
    //     ? const PaywallBScreen()
    //     : PaywallAScreen(
    //         paywallType: paywallType ?? '',
    //       );
  }
}
