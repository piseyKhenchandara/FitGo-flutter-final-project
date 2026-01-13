import 'package:fit_go/domain/models/exercise_instance.model.dart';

class Day {
  final String dayName;
  final bool isRestDay;
  final String? intensity;
  final List<ExerciseInstance> exercises;

  Day({
    required this.dayName,
    required this.isRestDay,
    this.intensity,
    required this.exercises,
  });

  void addExercise(ExerciseInstance exercise) {
    exercises.add(exercise);
  }
}
