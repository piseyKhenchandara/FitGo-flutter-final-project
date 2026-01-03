import 'dart:io';
import 'dart:typed_data';

import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/models/enums.dart';
import 'package:fit_go/service/validation_service.dart';
import 'package:flutter/foundation.dart';

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

  static double? saveWeight(double weight) {
    return userSetupController.weight = weight;
  }

  static double? saveBMI (double bmi) {
    return userSetupController.weight_avg = bmi;
  }


  static GoalType saveGoalType(GoalType choice) {
      return userSetupController.goal = choice;
  }

  static void saveSchedule(List<String> schedule) {
    userSetupController.schedule = schedule;
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
