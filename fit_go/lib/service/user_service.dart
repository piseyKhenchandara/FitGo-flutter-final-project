import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/service/validation_service.dart';
import 'package:flutter/material.dart';

class UserService {
  

  static String? saveUserInfo(String name, String ageText) {

    String? nameError = ValidationService.validateName(name);
    if(nameError !=null) return nameError;

    String? ageError = ValidationService.validateAge(ageText);
    if(ageError !=null) return ageError;

    int age = int.parse(ageText);
    userSetupController.name = name;
    userSetupController.age = age;
  }
}
