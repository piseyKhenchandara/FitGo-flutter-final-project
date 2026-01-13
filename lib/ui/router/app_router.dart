import 'package:fit_go/ui/mainscreen/homepage.dart';
import 'package:fit_go/ui/onboarding/onboarding_page.dart';

import 'package:fit_go/ui/setupscreen/gender_page.dart';
import 'package:fit_go/ui/setupscreen/height_page.dart';
import 'package:fit_go/ui/setupscreen/schedule_page.dart';
import 'package:fit_go/ui/setupscreen/user_info_page.dart';
import 'package:fit_go/ui/setupscreen/weight_avg_page.dart';
import 'package:fit_go/ui/setupscreen/weight_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter getRouter(bool isSetupComplete) {
    
    return GoRouter(
     initialLocation: isSetupComplete ? '/homepage' : '/homepage',

    redirect: (context, state) {
       
        if (isSetupComplete && 
            (state.uri.path.startsWith('/onboarding') || 
             state.uri.path.startsWith('/setup'))) {
          return '/homepage';  
        }
        return null; 
      },

    routes: [
      GoRoute(
        path: '/onboarding',
        name: "onboarding",
        builder: (context, state) => OnboardingPage(),
      ),

      GoRoute(
        path: '/setup/user_info',
        name: 'onboard',
        builder: (context, state) => const UserInfoPage(),
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
        builder: (context, state) => WeightPage(),
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
        path: '/setup/schedule',
        name: 'schedule',
        builder: (context, state) => SchedulePage(),
      ),

      GoRoute(
        path: '/homepage',
        name: 'homepage',
        builder: (context, state) => Homepage(),
      ),
    ],
  );
}
}

/* 
GoRoute(path: '/setup/weight_avg', name : 'weight_avg', builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return WeightAvgPage(
          weight: args?['weight'] as int?,
          height: args?['height'] as int?,
        );},


 */
