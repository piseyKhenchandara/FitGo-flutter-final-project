import 'package:fit_go/router/app_router.dart';
import 'package:fit_go/ui/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';


void main () {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(


      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      
    );
  }
}