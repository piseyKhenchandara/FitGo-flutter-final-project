import 'package:fit_go/ui/onboarding/onboarding_page.dart';
import 'package:fit_go/ui/onboarding/welcome_page.dart';
import 'package:flutter/material.dart';


void main () {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home : OnboardingPage(),
    );
  }
}