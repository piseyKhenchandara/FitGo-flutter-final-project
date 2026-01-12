import 'package:fit_go/domain/models/user_setup_controller.dart';
import 'package:fit_go/ui/helpers/snackbar_helper.dart';
import 'package:fit_go/domain/service/user_setup_service.dart';
import 'package:fit_go/ui/widgets/appbar.dart';
import 'package:fit_go/ui/widgets/back_next_button.dart';
import 'package:fit_go/ui/widgets/gender_widgets.dart';
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
            image: 'assets/icons/female_icon.png',
            text: 'Female',
            color: Colors.pink[500]!,
            isSelected: userSetupController.gender == 'female',
            onPressed: () {
              setState(() {
                userSetupController.gender = 'female';
              });
              UserService.saveGender('female');
            },
          ),

            GenderWidgets(
              image: 'assets/icons/male_icon.png',
              text: 'Male',
              color: Colors.blue[500]!,
              isSelected: userSetupController.gender == 'male',
              onPressed: () {
                setState(() {
                  userSetupController.gender = 'male';
                });
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