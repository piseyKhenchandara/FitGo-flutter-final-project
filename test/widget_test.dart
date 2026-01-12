import 'package:flutter_test/flutter_test.dart';
import 'package:fit_go/domain/models/user_setup_controller.dart';
import 'package:fit_go/domain/models/enums.dart';
import 'package:fit_go/domain/service/user_setup_service.dart';
import 'package:fit_go/domain/service/validation_service.dart';

void main() {
  group('Validation Tests', () {
    test('Name validation should reject empty name', () {
      final result = ValidationService.validateName('');
      expect(result, isNotNull);
    });

    test('Name validation should accept valid name', () {
      final result = ValidationService.validateName('John');
      expect(result, isNull);
    });

    test('Age validation should reject invalid age', () {
      final result = ValidationService.validateAge('5');
      expect(result, isNotNull);
    });

    test('Age validation should accept valid age', () {
      final result = ValidationService.validateAge('25');
      expect(result, isNull);
    });

    test('Schedule validation should require minimum 3 days', () {
      final result = ValidationService.validateSchedule(['monday', 'tuesday']);
      expect(result, isNotNull);
    });

    test('Schedule validation should accept 3 or more days', () {
      final result = ValidationService.validateSchedule(['monday', 'tuesday', 'wednesday']);
      expect(result, isNull);
    });
  });

  group('BMI Calculation Tests', () {
    test('BMI should be calculated correctly', () {
      userSetupController.height = 170; // cm
      userSetupController.weight = 70.0; // kg
      
      final bmi = UserService.calculateBMI();
      
      expect(bmi, isNotNull);
      expect(bmi!, greaterThan(24.0));
      expect(bmi, lessThan(25.0));
    });

    test('BMI should return null if height is missing', () {
      userSetupController.height = null;
      userSetupController.weight = 70.0;
      
      final bmi = UserService.calculateBMI();
      
      expect(bmi, isNull);
    });

    test('BMI should return null if weight is missing', () {
      userSetupController.height = 170;
      userSetupController.weight = null;
      
      final bmi = UserService.calculateBMI();
      
      expect(bmi, isNull);
    });
  });

  group('UserSetupController Tests', () {
    setUp(() {
      // Clear data before each test
      userSetupController.clear();
    });

    test('isComplete should be false when data is incomplete', () {
      expect(userSetupController.isComplete, isFalse);
    });

    test('isComplete should be true when all data is filled', () {
      userSetupController.name = 'John';
      userSetupController.age = 25;
      userSetupController.gender = 'male';
      userSetupController.height = 170;
      userSetupController.weight = 70.0;
      userSetupController.weight_avg = 24.5;
      userSetupController.bmi = 24.5;
      userSetupController.goal = GoalType.stayFit;
      userSetupController.schedule = ['monday', 'tuesday', 'wednesday'];
      
      expect(userSetupController.isComplete, isTrue);
    });

    test('toMap should convert controller to Map correctly', () {
      userSetupController.name = 'John';
      userSetupController.age = 25;
      userSetupController.gender = 'male';
      
      final map = userSetupController.toMap();
      
      expect(map['name'], 'John');
      expect(map['age'], 25);
      expect(map['gender'], 'male');
    });
  });
}