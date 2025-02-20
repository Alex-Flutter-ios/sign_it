import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/core/constants/assets.dart';
import 'package:scaner_test_task/core/utils/routers/routes.dart';
import 'package:scaner_test_task/core/widgets/custom_loader_widget.dart';
import 'package:scaner_test_task/core/widgets/header_widget.dart';
import 'package:scaner_test_task/features/subscription/presentation/views/widgets/total_widget.dart';
import '../cubit/subscription_cubit.dart';
import 'widgets/bottom_button.dart';
import 'widgets/feature_column.dart';
import 'widgets/gradient_button.dart';
import 'widgets/plan_row.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({
    super.key,
    this.paywallType,
    this.onClose,
    this.fromDocumentInfo = false,
  });
  final String? paywallType;
  final VoidCallback? onClose;
  final bool fromDocumentInfo;

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  late SubscriptionCubit subscriptionCubit;
  final String _trialProductId = 'qr.trial.7';
  final String _annualProductId = 'qr.notrial.5';
  bool _isTrialSelected = true;
  double totalPrice = 0.00;

  @override
  void initState() {
    subscriptionCubit = context.read<SubscriptionCubit>();
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionLoaded && state.isPremium) {
          if (widget.fromDocumentInfo) {
            // Возвращаемся назад с purchased=true
            Navigator.pop(context, true);
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.documents.name,
              (route) => false,
            );
          }

          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   Routes.documents.name,
          //   (route) => false,
          // );
        }
        if (state is SubscriptionError) {
          _showErrorDialog(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 241, 241, 241),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                                    child: HeaderWidget(),
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
                              onTap: () {
                                if (widget.fromDocumentInfo) {
                                  Navigator.pop(context, false);
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.documents.name,
                                    (route) => false,
                                  );
                                }
                              },
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
                        Row(
                          children: [
                            Expanded(
                              child: FeatureColumn(
                                icon: AppImageAssets.unlimitedSignature.asset,
                                label: 'Unlimited Signatures',
                              ),
                            ),
                            Expanded(
                              child: FeatureColumn(
                                icon: AppImageAssets.documentScanner.asset,
                                label: 'Document Scanner',
                              ),
                            ),
                            Expanded(
                              child: FeatureColumn(
                                icon: AppImageAssets.adFreeExperinece.asset,
                                label: 'Ad-Free Experience',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.4,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              // width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              // color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // 3-Day Free Trial
                                  PlanRow(
                                    title: '3-Day Free Trial',
                                    subtitle: 'then 4.99\$/week',
                                    price: '\$0.00',
                                    isSelected: _isTrialSelected,
                                    onTap: () {
                                      setState(() {
                                        _isTrialSelected = true;
                                        totalPrice = 0.00;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  // Annual plan
                                  PlanRow(
                                    title: 'Annual plan',
                                    subtitle: 'Enjoy unlimited access!',
                                    price: '\$39.99',
                                    isSelected: !_isTrialSelected,
                                    onTap: () {
                                      setState(() {
                                        _isTrialSelected = false;
                                        totalPrice = 39.99;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  widget.paywallType == 'b'
                                      ? TotalWidget(
                                          title: 'Total',
                                          price: '$totalPrice',
                                        )
                                      : const SizedBox.shrink(),

                                  GradientButton(
                                    onPressed: () async {
                                      final productId = _isTrialSelected
                                          ? _trialProductId
                                          : _annualProductId;

                                      try {
                                        await subscriptionCubit
                                            .purchase(productId);
                                      } catch (_) {}
                                    },
                                    title: _isTrialSelected
                                        ? 'Try For Free'
                                        : 'Continue',
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                          subscriptionCubit.restore();
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
                      if (state is SubscriptionLoading)
                        Center(child: CustomLoaderWidget()),
                    ],
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
