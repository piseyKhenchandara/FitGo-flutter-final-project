import 'package:fit_go/domain/models/day_model.dart';

class WorkoutplanModel {
  final List<Day> weeklySchedule;
  final List<Day> monthlyPlan;

  WorkoutplanModel({
    required this.weeklySchedule,
    required this.monthlyPlan,
  });


  Day? getExercisesForDay(int dayIndex) {
    if (dayIndex < 0 || dayIndex >= monthlyPlan.length) {
      return null;
    }
    return monthlyPlan[dayIndex];
  }


  int getTotalDurationOfDay(int dayIndex) {
    final dayInstance = getExercisesForDay(dayIndex);
    if (dayInstance == null || dayInstance.exercises.isEmpty) {
      return 0;
    }

    int totalDuration = 0;
    for (var exercise in dayInstance.exercises) {
      totalDuration += exercise.totalDurationSeconds;
    }
    return totalDuration;
  }


  String getTotalDurationForDay(int dayIndex) {
    final totalSeconds = getTotalDurationOfDay(dayIndex);
    
    if (totalSeconds == 0) {
      return 'Rest day';
    }

    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    if (minutes == 0) return '${seconds}s';
    if (seconds == 0) return '${minutes}m';
    return '${minutes}m ${seconds}s';
  }

 
  void completeRep(int dayIndex, int exerciseIndex) {
    final dayInstance = getExercisesForDay(dayIndex);
    if (dayInstance != null && 
        exerciseIndex >= 0 && 
        exerciseIndex < dayInstance.exercises.length) {
      dayInstance.exercises[exerciseIndex].completeRep();
    }
  }

  static Future<WorkoutplanModel?> fromMap(data) async {
    return null;
  }


}
