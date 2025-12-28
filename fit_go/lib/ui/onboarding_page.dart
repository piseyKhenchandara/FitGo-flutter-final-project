import 'package:fit_go/ui/hook_page.dart';
import 'package:fit_go/ui/welcome_page.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  void nextPage() {
    if (currentIndex < 4) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        children: [
          WelcomePage(onStart: nextPage),
          HookPage(
            image: 'assets/images/fitness.png',
            text: 'find the right workout for what you need',
            onNext: nextPage,
          ),
           HookPage(
            image: 'assets/images/andrew1.png',
            text: 'make suitable workouts and great results',
            onNext: nextPage,
          ),
          HookPage(
            image: 'assets/images/ronaldo1.png',
            text: 'let’s do a workout and live healthy with us',
            onNext: nextPage,
          ),
          HookPage(
            image: 'assets/images/muscle_vs_fat.png',
            text: 'let’s do a workout and live healthy with us',
            onNext: nextPage,
          ),
        ],
      ),
    );
  }
}
