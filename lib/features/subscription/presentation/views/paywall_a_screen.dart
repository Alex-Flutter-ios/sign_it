import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/core/constants/assets.dart';
import '../cubit/subscription_cubit.dart';
import '../../../../core/utils/routers/routes.dart';
import 'widgets/bottom_button.dart';
import 'widgets/gradient_button.dart';

class PaywallAScreen extends StatefulWidget {
  const PaywallAScreen({super.key});

  @override
  State<PaywallAScreen> createState() => _PaywallAScreenState();
}

class _PaywallAScreenState extends State<PaywallAScreen> {
  bool _isTrialSelected = true; // по умолчанию выбран trial

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        // Если подписка оформлена — переход на главный экран (DocumentsScreen)
        if (state is SubscriptionLoaded && state.isPremium) {
          Navigator.pushReplacementNamed(context, Routes.documents.name);
        }
        // Если ошибка — показываем диалог
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
        // Лоадер при покупке/восстановлении
        if (state is SubscriptionLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 241, 241, 241),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF364EFF),
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Sign ',
                                            style: TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'it',
                                            style: const TextStyle(
                                              fontFamily: 'DancingScrip',
                                              fontSize: 24,
                                              color: Color(0xFF364EFF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFDD24A),
                                    Color(0xFFFCC700),
                                    Color(0xFFFED977),
                                    Color(0xFFFDD24A),
                                    Color(0xFFFED977),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                child: Text(
                                  'PRO',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.close,
                                color: const Color.fromARGB(81, 255, 255, 255),
                                weight: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Premium Document\nSignature',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign documents anywhere, anywhere\nusing your mobile phone',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ---- Блок иконок/преимуществ (пример) ----
                        Row(
                          children: [
                            Expanded(
                              child: _FeatureColumn(
                                icon: AppImageAssets.unlimitedSignature.asset,
                                label: 'Unlimited Signatures',
                              ),
                            ),
                            Expanded(
                              child: _FeatureColumn(
                                icon: AppImageAssets.documentScanner.asset,
                                label: 'Document Scanner',
                              ),
                            ),
                            Expanded(
                              child: _FeatureColumn(
                                icon: AppImageAssets.adFreeExperinece.asset,
                                label: 'Ad-Free Experience',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ---- Блок планов ----
                  // ---- Тело скроллится ----
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 3-Day Free Trial
                                _PlanRow(
                                  title: '3-Day Free Trial',
                                  subtitle: 'then 4.99\$/week',
                                  price: '\$0.00',
                                  isSelected: _isTrialSelected,
                                  onTap: () {
                                    setState(() {
                                      _isTrialSelected = true;
                                    });
                                  },
                                ),
                                const SizedBox(height: 8),
                                // Annual plan
                                _PlanRow(
                                  title: 'Annual plan',
                                  subtitle: 'Enjoy unlimited access!',
                                  price: '\$39.99',
                                  isSelected: !_isTrialSelected,
                                  onTap: () {
                                    setState(() {
                                      _isTrialSelected = false;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),

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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BottobButton(
                                      text: 'Terms',
                                      onPressed: () {},
                                    ),
                                    const Spacer(),
                                    BottobButton(
                                      text: 'Privacy',
                                      onPressed: () {},
                                    ),
                                    const Spacer(),
                                    BottobButton(
                                      text: 'Restore',
                                      onPressed: () {
                                        context
                                            .read<SubscriptionCubit>()
                                            .restore();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---- Вспомогательные виджеты ----

class _PlanRow extends StatelessWidget {
  const _PlanRow({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF2F4FF),
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: isSelected ? const Color(0xFF364EFF) : Color(0xFFF2F4FF),
            width: isSelected ? 2 : 0,
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(255, 124, 124, 124),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureColumn extends StatelessWidget {
  const _FeatureColumn({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(icon),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
