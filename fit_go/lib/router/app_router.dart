import 'package:fit_go/ui/setup/gender_page.dart';
import 'package:fit_go/ui/setup/height_page.dart';
import 'package:fit_go/ui/setup/user_info_page.dart';
import 'package:fit_go/ui/setup/weight_avg_page.dart';
import 'package:fit_go/ui/setup/weight_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/height_page',

    routes: [

      GoRoute(path: '/setup/gender', name : 'gender', builder: (context, state) => GenderPage(),),

      GoRoute(path: '/setup/height', name:  "height" , builder:(context, state) => HeightPage(), ),

      GoRoute(path: '/setup/weight', name : 'weight',
      builder: (context, state) => WeightPage(),),

      GoRoute(path: '/setup/user_info', name : 'user_info', builder: (context, state) => UserInfoPage(),),

      GoRoute(path: '/setup/weight_avg', name : 'weight_avg', builder: (context, state) => WeightAvgPage(),),





      
      


    ],
  );
}
