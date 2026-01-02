import 'dart:io';
import 'dart:typed_data';

import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/models/enums.dart';
import 'package:fit_go/service/validation_service.dart';
import 'package:flutter/foundation.dart';
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

    return null;
    
  }


  static void saveProfileImage(File? mobileImage, Uint8List? webImage) {
    if(kIsWeb && webImage !=null) {
      userSetupController.profileImageWeb = webImage;

    }
    else if(mobileImage !=null) {
      userSetupController.profileImage = mobileImage;
    }
  }


  static String? saveGender(String gender) {

    return userSetupController.gender = gender;
  }

  static int? saveHeight(int height) {
    return userSetupController.height = height;
  }

  static int? saveWeight(int weight) {
    return userSetupController.weight = weight;
  }


  static GoalType saveGoalType(GoalType choice) {
      return userSetupController.goal = choice;
  }

  static double? calculateBMI() {

    if(userSetupController.height == null || userSetupController.weight == null) {
      return null;
    }
    double heightInMeters = userSetupController.height! /100;
    double bmi = userSetupController.weight! /(heightInMeters * heightInMeters);

    return bmi;
  }







}
