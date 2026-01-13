import 'package:fit_go/domain/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_go/domain/models/enums.dart';
import 'package:fit_go/domain/service/user_setup_service.dart';
import 'package:fit_go/domain/service/validation_service.dart';

late UserModel user;

void main() {
  setUp(() {
    // Initialize user instance before each test group
    user = UserModel();
  });
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
      user.height = 170; // cm
      user.weight = 70.0; // kg
      
      final bmi = UserService.calculateBMI();
      
      expect(bmi, isNotNull);
      expect(bmi!, greaterThan(24.0));
      expect(bmi, lessThan(25.0));
    });

    test('BMI should return null if height is missing', () {
      user.height = null;
      user.weight = 70.0;
      
      final bmi = UserService.calculateBMI();
      
      expect(bmi, isNull);
    });

    test('BMI should return null if weight is missing', () {
      user.height = 170;
      user.weight = null;
      
      final bmi = UserService.calculateBMI();
      
      expect(bmi, isNull);
    });
  });

  group('user Tests', () {
    test('isComplete should be false when data is incomplete', () {
      expect(user.isComplete, isFalse);
    });

    test('isComplete should be true when all data is filled', () {
      user.name = 'John';
      user.age = 25;
      user.gender = 'male';
      user.height = 170;
      user.weight = 70.0;
      user.weight_avg = 24.5;
      user.bmi = 24.5;
      user.goal = GoalType.stayFit;
      user.weeklySchedule = ['monday', 'tuesday', 'wednesday'];
      
      expect(user.isComplete, isTrue);
    });

    test('toMap should convert controller to Map correctly', () {
      user.name = 'John';
      user.age = 25;
      user.gender = 'male';
      
      final map = user.toMap();
      
      expect(map['name'], 'John');
      expect(map['age'], 25);
      expect(map['gender'], 'male');
    });
  });
}