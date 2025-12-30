import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/widgets/appbar.dart';
import 'package:fit_go/widgets/gender_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String? selectedGender;
  @override
  Widget build(BuildContext context) {
    return Container(

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
                userSetupController.gender = 'female';
                context.go('/setup/height');
              }
          ),
        

          GenderWidgets(
              image :'assets/icons/male_icon.png',
              text : 'male',
              color : Colors.blue[300]!,
              onPressed: () {
                userSetupController.gender = 'male';
                context.go('/setup/height');
              },
          ), 


       
        ],
      ),
    );
  }
}