import 'package:fit_go/models/activity_model.dart';

class DayWorkout {
  final String dayName;
  final List<String> muscleGroups;
  final List<ActivityModel> exercises;
  final Duration duration;
  final int totalExercises;

  DayWorkout({
    required this.dayName,
    required this.muscleGroups,
    required this.exercises,
    required this.duration,
    required this.totalExercises
  });
}
