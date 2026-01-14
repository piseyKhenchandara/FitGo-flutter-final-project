import 'dart:convert';
import 'dart:io';
import 'package:fit_go/domain/models/user_model.dart';

import 'package:fit_go/domain/models/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorageService {




  static Future<void> saveToFile() async {
    try{
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/user_setup.json');
      final jsonString = jsonEncode(user.toMap());
      await file.writeAsString(jsonString);
      print('save to file : ${file.path}');
      

    }
    catch(error) {
      print('Error saving o file : $error');
    }
  }



  static Future<void> saveToWebStorage() async {
    
    try{
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(user.toMap());
      await prefs.setString('user_setup', jsonString);
      print('Saved to web storage');
    }
    catch(error) {
      print('Error saving to web storage : $error');
    }
  }

  static Future<void> saveUserSetup() async {
    if(kIsWeb) {
      await saveToWebStorage();

    }
    else {
      await saveToFile();
    }
  }

  
  static Future<bool> loadFromFile() async {

    try{
      final dir = await getApplicationDocumentsDirectory();

      final file = File('${dir.path}/user_setup.json');

      if(!await file.exists()) {
        print('File does not exist');
        return false;
      }

      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString);

      _loadDataIntoController(data);
      return true;
    }
    catch(error){
      print('Error loading from file : $error');
      return false;
    }
  }

  static Future<bool> loadFromWebStorage()  async {
    try{
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('user_setup');

      if(jsonString == null) {
        print('NO data in web storage');
        return false;
      }
      final data = jsonDecode(jsonString);
      _loadDataIntoController(data);
      print('Loaded from web storage');

      return true;
    }
    catch(error) {
      print('Error loading from web storage : $error');
      return false;
    }
  }

  static Future<bool> loadUserSetup() async {
    if(kIsWeb) {
      return await loadFromWebStorage();
    }
    else {
      return await loadFromFile();
    }

  }


  static void _loadDataIntoController(Map<String, dynamic> data) {
  user.name = data['name'];
  user.age = data['age'];
  user.bmi = data['bmi'];
  user.gender = data['gender'];
  user.height = data['height'];
  user.weight = data['weight']?.toDouble();
  user.weight_avg = data['weight_avg']?.toDouble();
  
  if (data['weeklySchedule'] != null) {
    user.weeklySchedule = List<String>.from(data['weeklySchedule']);
  }
  
  if (data['goal'] != null) {
    user.goal = GoalType.values.firstWhere(
      (e) => e.name == data['goal'],
      orElse: () => GoalType.stayFit,
    ) as GoalType?;
  }
  
  if (data['imageData'] != null && data['imageData'] != '') {
    try {
      user.profileImageWeb = base64Decode(data['imageData']);
      print(' Image loaded!');
    } catch (e) {
      print(' Image error: $e');
    }
  }
}






  
}