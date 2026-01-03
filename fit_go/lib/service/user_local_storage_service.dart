import 'dart:convert';
import 'dart:io';

import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorageService {




  static Future<void> saveToFile() async {
    try{
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/user_setup.json');
      final jsonString = jsonEncode(userSetupController.toMap());
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
      final jsonString = jsonEncode(userSetupController.toMap());
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
    userSetupController.name = data['name'];
    userSetupController.age = data['age'];
    userSetupController.gender = data['gender'];
    userSetupController.height = data['height'];
    userSetupController.weight = data['weight'];
    userSetupController.weight_avg = data['weight_avg'];
    userSetupController.schedule = data['schedule'];

  }

  
  


  




}