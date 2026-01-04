import 'package:fit_go/models/workout_day.dart';


class WorkoutPlans {

  static const Map<String, WorkoutDay> threeDayPlan = {

    'day1' : WorkoutDay(
      name : 'Push day', 
      muscleGroups: ['shoulder', 'arms'], 
      exerciseCounts: {'shoulder' : 5, 'arms' : 5}
    ),

    'day2': WorkoutDay(
      name: 'LEG DAY',
      muscleGroups: ['legs'],
      exerciseCounts: {'legs': 8},
    ),

    'day3': WorkoutDay(
      name: 'PULL DAY',
      muscleGroups: ['back', 'arms'],
      exerciseCounts: {'back': 5, 'arms': 5},
    ),

  };


  static const Map<String, WorkoutDay> fourDayPlan = {
    'day1': WorkoutDay(
      name: 'UPPER PUSH',
      muscleGroups: ['shoulder', 'arms'],
      exerciseCounts: {'shoulder': 5, 'arms': 4},
    ),
    'day2': WorkoutDay(
      name: 'LOWER',
      muscleGroups: ['legs'],
      exerciseCounts: {'legs': 8},
    ),
    'day3': WorkoutDay(
      name: 'UPPER PULL',
      muscleGroups: ['back', 'arms'],
      exerciseCounts: {'back': 5, 'arms': 4},
    ),
    'day4': WorkoutDay(
      name: 'LOWER',
      muscleGroups: ['legs'],
      exerciseCounts: {'legs': 6},
    ),
  };


  static const Map<String, WorkoutDay> fiveDayPlan = {
    'day1': WorkoutDay(
      name: 'CHEST & SHOULDERS',
      muscleGroups: ['shoulder'],
      exerciseCounts: {'shoulder': 5},
    ),
    'day2': WorkoutDay(
      name: 'BACK',
      muscleGroups: ['back'],
      exerciseCounts: {'back': 5},
    ),
    'day3': WorkoutDay(
      name: 'LEGS',
      muscleGroups: ['legs'],
      exerciseCounts: {'legs': 8},
    ),
    'day4': WorkoutDay(
      name: 'SHOULDERS',
      muscleGroups: ['shoulder'],
      exerciseCounts: {'shoulder': 5},
    ),
    'day5': WorkoutDay(
      name: 'ARMS',
      muscleGroups: ['arms'],
      exerciseCounts: {'arms': 10},
    ),
  };



  static const Map<String, WorkoutDay> sixDayPlan = {
    'day1': WorkoutDay(
      name: 'PUSH',
      muscleGroups: ['shoulder', 'arms'],
      exerciseCounts: {'shoulder': 5, 'arms': 4},
    ),
    'day2': WorkoutDay(
      name: 'PULL',
      muscleGroups: ['back', 'arms'],
      exerciseCounts: {'back': 5, 'arms': 4},
    ),
    'day3': WorkoutDay(
      name: 'LEGS',
      muscleGroups: ['legs'],
      exerciseCounts: {'legs': 7},
    ),
    'day4': WorkoutDay(
      name: 'PUSH',
      muscleGroups: ['shoulder', 'arms'],
      exerciseCounts: {'shoulder': 5, 'arms': 3},
    ),
    'day5': WorkoutDay(
      name: 'PULL',
      muscleGroups: ['back', 'arms'],
      exerciseCounts: {'back': 4, 'arms': 4},
    ),
    'day6': WorkoutDay(
      name: 'LEGS',
      muscleGroups: ['legs'],
      exerciseCounts: {'legs': 6},
    ),
  };


  static Map<String, WorkoutDay> getPlanForDays(int dayCount) {
  
    if (dayCount >= 7) dayCount = 6;
    
    switch (dayCount) {
      case 3:
        return threeDayPlan;
      case 4:
        return fourDayPlan;
      case 5:
        return fiveDayPlan;
      case 6:
        return sixDayPlan;
      default:
        return threeDayPlan;
    }
  }




}
