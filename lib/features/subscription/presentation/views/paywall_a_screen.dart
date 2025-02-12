import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/subscription_cubit.dart';

class PaywallAScreen extends StatelessWidget {
  const PaywallAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Заголовок
              const Text(
                'Premium Access',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Изображение (замените на свое)
              Image.asset('assets/paywall_a_image.png'),

              // Цена
              const Text(
                '\$9.99/month',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Кнопка подписки
              ElevatedButton(
                onPressed: () =>
                    context.read<SubscriptionCubit>().purchase('annual'),
                child: const Text('Subscribe Now'),
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
