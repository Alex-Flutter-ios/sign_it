import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/subscription_cubit.dart';

class PaywallBScreen extends StatelessWidget {
  const PaywallBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Заголовок с триалом
              const Text(
                'Try Premium Free',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Изображение (замените на свое)
              Image.asset('assets/paywall_b_image.png'),

              // Цена с триалом
              const Column(
                children: [
                  Text(
                    '\$0.0',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text('3-day free trial, then \$9.99/month'),
                ],
              ),
              const SizedBox(height: 16),

              // Кнопка подписки
              ElevatedButton(
                onPressed: () =>
                    context.read<SubscriptionCubit>().purchase('weekly'),
                child: const Text('Start Free Trial'),
              ),

              // Восстановление покупок
              TextButton(
                onPressed: () => context.read<SubscriptionCubit>().restore(),
                child: const Text('Restore Purchase'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
