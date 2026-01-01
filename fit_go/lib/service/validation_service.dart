class ValidationService {


  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your name';
    }
    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Name can only contain letters';
    }
    return null; 
  }


  static String? validateAge(String? ageText) {
    if(ageText == null || ageText.isEmpty) {
      return "Please enter your age";
    }

    int? age = int.tryParse(ageText);

    if(age == null) {
      return 'please enter a valid number';
    }

    if(age < 13 || age > 120) {
      return 'Please enter a valid age(13-120)';

    }
     return null;
  }

}
