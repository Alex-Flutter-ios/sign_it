import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/subscription_cubit.dart';
import '../../../../core/utils/routers/routes.dart';
import 'widgets/gradient_button.dart';

class PaywallBScreen extends StatefulWidget {
  const PaywallBScreen({super.key});

  @override
  State<PaywallBScreen> createState() => _PaywallBScreenState();
}

class _PaywallBScreenState extends State<PaywallBScreen> {
  bool _isTrialSelected = true; // по умолчанию trial

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
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // ---- Шапка ----
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: const Color(0xFF5436FF),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Лого
                      Row(
                        children: [
                          Image.asset(
                            'assets/subscription/it.png',
                            height: 32,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Sign it',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Бейдж PRO
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---- Тело скроллится ----
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // ---- Заголовок и описание ----
                        Container(
                          width: double.infinity,
                          color: const Color(0xFF5436FF),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const Text(
                                'Premium Document\nSignature (B)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Exclusive Offer! Sign documents\nanywhere using your mobile phone',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  _FeatureColumnB(
                                    icon: Icons.lock_open,
                                    label: 'Full Access',
                                  ),
                                  _FeatureColumnB(
                                    icon: Icons.edit,
                                    label: 'Unlimited',
                                  ),
                                  _FeatureColumnB(
                                    icon: Icons.support_agent,
                                    label: 'Support',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ---- Блок планов ----
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 3-Day Free Trial
                              _PlanRowB(
                                title: '3-Day Free Trial',
                                price: '\$0.00',
                                isSelected: _isTrialSelected,
                                onTap: () {
                                  setState(() {
                                    _isTrialSelected = true;
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                              // Monthly plan (пример)
                              _PlanRowB(
                                title: 'Monthly plan',
                                price: '\$4.99',
                                isSelected: !_isTrialSelected,
                                onTap: () {
                                  setState(() {
                                    _isTrialSelected = false;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // ---- Кнопка CTA ----

                              GradientButton(
                                onPressed: () {
                                  final cubit =
                                      context.read<SubscriptionCubit>();
                                  if (_isTrialSelected) {
                                    cubit.purchase('trial_package_b');
                                  } else {
                                    cubit.purchase('monthly_package_b');
                                  }
                                },
                                title: _isTrialSelected
                                    ? 'Try For Free'
                                    : 'Subscribe Now',
                              ),
                              // SizedBox(
                              //   height: 48,
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor: const Color(0xFF5436FF),
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(8),
                              //       ),
                              //     ),
                              //     onPressed: () {
                              //       final cubit =
                              //           context.read<SubscriptionCubit>();
                              //       if (_isTrialSelected) {
                              //         cubit.purchase('trial_package_b');
                              //       } else {
                              //         cubit.purchase('monthly_package_b');
                              //       }
                              //     },
                              //     child: Text(
                              //       _isTrialSelected
                              //           ? 'Try For Free'
                              //           : 'Subscribe Now',
                              //       style: const TextStyle(
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              // ---- Кнопка Restore ----
                              TextButton(
                                onPressed: () {
                                  context.read<SubscriptionCubit>().restore();
                                },
                                child: const Text(
                                  'Restore Purchase',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ---- Низ экрана: ссылки Terms | Privacy ----
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // TODO: открыть Terms
                        },
                        child: const Text('Terms'),
                      ),
                      const Text('|', style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          // TODO: открыть Privacy
                        },
                        child: const Text('Privacy'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---- Вспомогательные виджеты ----

class _PlanRowB extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanRowB({
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5436FF).withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF5436FF) : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Радиокнопка
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF5436FF) : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureColumnB extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureColumnB({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(icon, color: const Color(0xFF5436FF)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
