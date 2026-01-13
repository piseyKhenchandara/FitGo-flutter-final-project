import 'dart:io';
import 'dart:typed_data';

import 'package:fit_go/domain/models/user_model.dart';
import 'package:fit_go/domain/service/validation_service.dart';
import 'package:fit_go/domain/models/enums.dart';

import 'package:flutter/foundation.dart';

class UserService {
  

  static String? saveUserInfo(String name, String ageText) {

    String? nameError = ValidationService.validateName(name);
    if(nameError !=null) return nameError;

    String? ageError = ValidationService.validateAge(ageText);
    if(ageError !=null) return ageError;

    int age = int.parse(ageText);
    user.name = name;
    user.age = age;

    return null;
    
  }


  static void saveProfileImage(File? mobileImage, Uint8List? webImage) {
    if(kIsWeb && webImage !=null) {
      user.profileImageWeb = webImage;

    }
    else if(mobileImage !=null) {
      user.profileImage = mobileImage;
    }
  }


  static String? saveGender(String gender) {

    return user.gender = gender;
  }

  static int? saveHeight(int height) {
    return user.height = height;
  }

  static double? saveWeight(double weight) {
    return user.weight = weight;
  }


  static void saveSchedule(List<String> schedule) {
    user.weeklySchedule = schedule;
  }



  static double? calculateBMI() {

    if(user.height == null || user.weight == null) {
      return null;
    }
    double heightInMeters = user.height! /100;
    double bmi = user.weight! /(heightInMeters * heightInMeters);

    return bmi;
  }

  static double? saveBMI (double bmi) {
    return user.bmi = bmi;
  }


  static GoalType? saveGoalType(GoalType? choice) {
      return user.goal = choice;
  }
 



}
