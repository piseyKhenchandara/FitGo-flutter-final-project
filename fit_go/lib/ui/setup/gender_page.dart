import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/helpers/snackbar_helper.dart';
import 'package:fit_go/service/user_service.dart';
import 'package:fit_go/widgets/appbar.dart';
import 'package:fit_go/widgets/back_next_button.dart';
import 'package:fit_go/widgets/gender_widgets.dart';
import 'package:flutter/material.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body : Container(

      color: Colors.blue[400],

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
            child: Appbar(),
          ),

          const Text(
            'Gender',
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),

          GenderWidgets(
              image : 'assets/icons/female_icon.png',
              text : 'female',
              color : Colors.pink[300]!,
              onPressed: () {
                UserService.saveGender('female');
                
              }
          ),
        

          GenderWidgets(
              image :'assets/icons/male_icon.png',
              text : 'male',
              color : Colors.blue[300]!,
              onPressed: () {
                UserService.saveGender('male');
                
              },
          ), 


              BackNextButton(
                go_back: true,
                go_next: true, 
                backRoute: '/setup/user_info',
                nextRoute: '/setup/height',
                onNext: () {
                  // Validation: ensure gender is selected
                  if (userSetupController.gender == null) {
                    SnackbarHelper.showError(context, "please select a gender");
                    return false;
                  }

                  if(userSetupController.gender == 'female' || userSetupController.gender == 'male') {
                    SnackbarHelper.showInfo(context, 'You selected ${userSetupController.gender}');

                  }
                  return true;
                },
              ),

          


       
        ],
      ),
    ),
  );
  }
}