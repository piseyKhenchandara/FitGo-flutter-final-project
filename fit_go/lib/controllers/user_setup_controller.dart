import 'dart:io';
import 'dart:typed_data';

import 'package:fit_go/models/enums.dart';

class UserSetupController {
  String? gender;
  int? height;
  int? weight;
  int? weight_avg;

  String? name;
  int? age;
  File? profileImage;
  Uint8List? profileImageWeb;

  GoalType? goal;
  List<String>? schedule;

  bool get isComplete {
    return gender != null &&
        height != null &&
        weight != null &&
        weight_avg != null &&
        name != null &&
        age != null &&
        schedule !=null && schedule!.length >=3;
  }

  // use for saving data to local storage or sharedpreferences or json file
  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'height': height,
      "weight": weight,
      "weight_avg": weight_avg,
      'name': name,
      'age': age,
      'goal' : goal?.name,
      'schedule' : schedule

      // Error: type 'File' is not a subtype of type 'String' in JSON (so we donn't have to write both profile image and profileimageweb into this path)
    };
  }

  void clear() {
    gender = null;
    height = null;
    weight = null;
    name = null;
    age = null;
    profileImage = null;
    profileImageWeb = null;
    goal = null;
    schedule = null;
  }
}

final userSetupController = UserSetupController();
