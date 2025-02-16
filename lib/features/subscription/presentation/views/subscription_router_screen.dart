import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/core/utils/routers/routes.dart';
import '../cubit/subscription_cubit.dart';
import 'paywall_a_screen.dart';

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
    await cubit.checkSubscription();
    final currentState = cubit.state;
    if (currentState is SubscriptionLoaded && currentState.isPremium) {
      setState(() => isPremium = true);
      return;
    }

    final type = await cubit.getPaywallType();

    setState(() {
      isPremium = false;
      paywallType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isPremium == null && paywallType == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    if (isPremium == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, Routes.documents.name);
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    return PaywallScreen(paywallType: paywallType ?? '');
    // return paywallType == 'b'
    //     ? const PaywallBScreen()
    //     : PaywallAScreen(
    //         paywallType: paywallType ?? '',
    //       );
  }
}
