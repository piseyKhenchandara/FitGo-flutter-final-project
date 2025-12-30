class UserSetupController {
  String? gender;
  int? height;
  int? weight;
  int? weight_avg;
  
  String? name;
  int? age;

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
    };
  }


  void clear() {
    gender = null;
    height = null;
    weight = null;
    name = null;
    age = null;

  }
}

final userSetupController = UserSetupController();