import 'dart:math';
import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/data/gym_data/activity.dart';
import 'package:fit_go/models/enums.dart';

class UserActivity {
  List<String> schedule;

  Map<int, List<Map<String, dynamic>>> dayActivities = {};

  static const Map<String, Map<String, Map<String, int>>> exerciseAllocationByGoal = {
    'stayFit': {
      'low': {'arms': 6, 'back': 5, 'legs': 7, 'shoulder': 5},
      'medium': {'arms': 5, 'back': 4, 'legs': 6, 'shoulder': 4},
      'high': {'arms': 4, 'back': 3, 'legs': 5, 'shoulder': 3},
    },
    'gainMuscle': {
      'low': {'arms': 10, 'back': 8, 'legs': 10, 'shoulder': 7},
      'medium': {'arms': 9, 'back': 7, 'legs': 9, 'shoulder': 6},
      'high': {'arms': 8, 'back': 6, 'legs': 8, 'shoulder': 5},
    },
    'loseWeight': {
      'low': {'arms': 4, 'back': 3, 'legs': 5, 'shoulder': 3},
      'medium': {'arms': 3, 'back': 2, 'legs': 4, 'shoulder': 2},
      'high': {'arms': 2, 'back': 2, 'legs': 3, 'shoulder': 2},
    },
  };


  UserActivity({List<String>? scheduleOverride}) : schedule = scheduleOverride ?? userSetupController.schedule ?? [] {_generateActivitiesFor30Days();}

  void _generateActivitiesFor30Days() {
    final random = Random();
    String intensity = _getIntensity();
    String goalKey = _getGoalKey();

    // Get allocation based on goal AND intensity
    final allocation = exerciseAllocationByGoal[goalKey]?[intensity];

    if(allocation == null) {
      print('Error : No allocation found for goal = $goalKey, intensity=$intensity');
      return;
    }

    for(int day = 0 ; day <30 ; day++) {

      List<Map<String, dynamic>> dayExercises = [];

      int dayOfWeek = day %7;
      bool isWorkoutDay = dayOfWeek < schedule.length;

      if(isWorkoutDay) {

        allocation.forEach((muscleType, count) {
          final exercisesForType = activity.where((act) => act.type == muscleType).toList();

          if(exercisesForType.isNotEmpty) {
            for(int i = 0 ; i < count ; i++) {
              final selectedExercise = exercisesForType[random.nextInt(exercisesForType.length)];

              final totalSeconds = selectedExercise.time.inSeconds;
              final totalReps = selectedExercise.amount;
              final durationPerRepSeconds = (totalSeconds/totalReps).ceil();

              dayExercises.add({
                'id' : selectedExercise.id,
                'name' : selectedExercise.name,
                'image' : selectedExercise.image,
                'type' : selectedExercise.type,
                'reps' : totalReps,
                'completedReps' : 0,
                'durationPerRepSeconds' : durationPerRepSeconds,
                'totalDurationSeconds' : totalSeconds,
                'remainingSeconds' : totalSeconds,
                'completed' : false,
              });
            }
          }
        });
        dayActivities[day] = dayExercises;
      }

    }



  }
  String _getIntensity() {

    if(schedule.length ==3) {
      return 'low';
    }
    else if(schedule.length>=4 && schedule.length<=5) {
      return 'medium';
    }
    else{
      return 'high';
    }

  }

  String _getGoalKey(){
    final goal = userSetupController.goal;

    switch(goal) {
      case GoalType.stayFit:
        return 'stayFit';
      case GoalType.gainMuscle:
        return 'gainMuscle';
      case GoalType.loseWeight:
        return 'loseWeight';
      default : 
        return 'stayFit';  
    }
  }

  List<Map<String, dynamic>> getActivitiesForDay(int dayIndex) {

    if(dayIndex < 0 || dayIndex >=30) {

      return [];
    }
    return dayActivities[dayIndex] ?? [];


  }

  String getTotalDurationForDay(int dayIndex) {

    final dayExercises = getActivitiesForDay(dayIndex);

    if(dayExercises.isEmpty) {
      return 'Rest day';
    }

    final totalSeconds = dayExercises.fold(0,(sum, activity) => sum + (activity['totalDurationSeconds'] as int));

    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds %60;

    if(minutes == 0) {
      return '${seconds}s';

    }
    else if(seconds == 0){
      return '${minutes}mn';
    }
    else {
      return '${minutes}m ${seconds}s';
    }


  }


  

  



}
