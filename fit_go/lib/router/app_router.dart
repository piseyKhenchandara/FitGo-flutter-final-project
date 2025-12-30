import 'package:fit_go/ui/home/homepage.dart';
import 'package:fit_go/ui/onboarding/onboarding_page.dart';

import 'package:fit_go/ui/setup/gender_page.dart';
import 'package:fit_go/ui/setup/height_page.dart';
import 'package:fit_go/ui/setup/user_info_page.dart';
import 'package:fit_go/ui/setup/weight_avg_page.dart';
import 'package:fit_go/ui/setup/weight_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',

    routes: [
      GoRoute(
        path: '/onboarding',
        name: "onboarding",
        builder: (context, state) => OnboardingPage(),
      ),
      GoRoute(
        path: '/setup/gender',
        name: 'gender',
        builder: (context, state) => GenderPage(),
      ),
      GoRoute(
        path: '/setup/height',
        name: "height",
        builder: (context, state) => HeightPage(),
      ),
      GoRoute(
        path: '/setup/weight',
        name: 'weight',
        builder: (context, state) => WeightPage(height: state.extra as int?),
      ),
      GoRoute(
        path: '/setup/user_info',
        name: 'user_info',
        builder: (context, state) => UserInfoPage(),
      ),

      GoRoute(
        path: '/setup/weight_avg',
        name: 'weight_avg',
        builder: (context, state) => const WeightAvgPage(),
      ),
      GoRoute(
        path: '/homepage',
        name: 'homepage',
        builder: (context, state) => Homepage(),
      ),
    ],
  );
}

/* 
GoRoute(path: '/setup/weight_avg', name : 'weight_avg', builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return WeightAvgPage(
          weight: args?['weight'] as int?,
          height: args?['height'] as int?,
        );},


 */
