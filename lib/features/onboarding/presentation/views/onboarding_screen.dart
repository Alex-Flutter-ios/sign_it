import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:scaner_test_task/core/utils/routers/routes.dart';
import 'package:scaner_test_task/core/widgets/custom_loader_widget.dart';
import '../cubit/onboarding_cubit.dart';
import 'widgets/onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          body: state is OnboardingShow
              ? OnboardingContent(firstTime: state.firstTime)
              : const Center(child: CustomLoaderWidget()),
        );
      },
    );
  }
}

class OnboardingContent extends StatefulWidget {
  const OnboardingContent({super.key, required this.firstTime});
  final bool firstTime;

  @override
  State<OnboardingContent> createState() => OnboardingContentState();
}

class OnboardingContentState extends State<OnboardingContent> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        if (_controller.page! < _currentPage) {
          _controller.jumpToPage(_currentPage);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showRating() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);

    if (index == 1) {
      _showRating();
    }
  }

  Widget _buildPageIndicator() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          2,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? Theme.of(context).primaryColor
                  : Color(0xFFF5F5F5),
            ),
          ),
        ),
      );

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GradientButton(
              currentPage: _currentPage,
              controller: _controller,
              context: context,
              widget: widget,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          Navigator.pushReplacementNamed(context, Routes.subscription.name);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFF364EFF),
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _controller,
                            onPageChanged: _onPageChanged,
                            children: [
                              OnboardingPage(
                                image: 'assets/onboarding/onboarding1.png',
                                title: 'Effortlessly Sign Documents',
                                description:
                                    'Sign any document instantly with your digital signature',
                              ),
                              OnboardingPage(
                                image: 'assets/onboarding/onboarding2.png',
                                title: 'Create & Save Signatures',
                                description:
                                    'Design and store yourpersonalized signature for quick access',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavigationButtons(),
                      _buildPageIndicator(),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required int currentPage,
    required PageController controller,
    required this.context,
    required this.widget,
  })  : _currentPage = currentPage,
        _controller = controller;

  final int _currentPage;
  final PageController _controller;
  final BuildContext context;
  final OnboardingContent widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34.0),
        gradient: LinearGradient(
          colors: [
            Color(0xFF364EFF),
            Color(0xFF5436FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // color: buttonColor,
      ),
      child: TextButton(
        onPressed: () {
          if (_currentPage < 1) {
            _controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            context
                .read<OnboardingCubit>()
                .completeOnboarding(widget.firstTime);
          }
        },
        child: Text(
          'Continue',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            // fontFamily: "Urbanist",
          ),
        ),
      ),
    );
  }
}
