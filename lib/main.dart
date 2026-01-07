import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/router/app_router.dart';
import 'package:fit_go/service/user_local_storage_service.dart';
import 'package:flutter/material.dart';


void main () async{

  WidgetsFlutterBinding.ensureInitialized();

  bool hasData = await UserLocalStorageService.loadUserSetup();

  bool isSetupComplete = hasData && userSetupController.isComplete;

  runApp( MyApp(isSetupComplete : isSetupComplete));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isSetupComplete});
  
  final bool isSetupComplete;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(


      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.getRouter(isSetupComplete),
      
    );
  }
}