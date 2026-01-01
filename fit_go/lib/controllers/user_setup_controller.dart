import 'dart:io';
import 'dart:typed_data';

class UserSetupController {
  String? gender;
  int? height;
  int? weight;
  int? weight_avg;
  
  String? name;
  int? age;
  File? profileImage;
  Uint8List? profileImageWeb;

  bool get isComplete{
    return gender !=null && height !=null && weight !=null && weight_avg !=null && name!=null && age !=null;
  }

  // use for saving data to local storage or sharedpreferences or json file
  Map<String, dynamic> toMap() {
    return {
      'gender' : gender,
      'height' : height,
      "weight" : weight,
      "weight_avg" : weight_avg,
      'name'  : name,
      'age' : age,
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

  }
}

final userSetupController = UserSetupController();