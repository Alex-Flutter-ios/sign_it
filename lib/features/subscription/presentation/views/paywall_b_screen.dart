import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/subscription_cubit.dart';
import '../../../../core/utils/routers/routes.dart';

class PaywallBScreen extends StatelessWidget {
  const PaywallBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionLoaded && state.isPremium) {
          Navigator.pushReplacementNamed(context, Routes.documents.name);
        }
        if (state is SubscriptionError) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Ошибка'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SubscriptionLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Paywall B'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  'Paywall B: Эксклюзивная подписка',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Особое предложение для модерации / тестирования.',
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.read<SubscriptionCubit>().purchase('package_b');
                  },
                  child: const Text('Оформить подписку'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<SubscriptionCubit>().restore();
                  },
                  child: const Text('Восстановить покупки'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
