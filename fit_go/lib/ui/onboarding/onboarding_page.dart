import 'package:fit_go/data/hook_page.dart';
import 'package:fit_go/ui/onboarding/hook_page.dart';
import 'package:fit_go/ui/onboarding/welcome_page.dart';
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
    if (currentIndex < hookPages.length) {
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
          ...hookPages.map((page) => HookPage(
            image: page.image,
            text: page.text,
            onNext: nextPage,
          )),
        ],
      ),
    );
  }
}