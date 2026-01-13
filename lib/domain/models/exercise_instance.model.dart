import 'package:fit_go/domain/models/activity_model.dart';

class ExerciseInstance {
  final String id;
  final ActivityModel template;
  final int reps;
  int completedReps;
  final int durationPerRepSeconds;
  final int totalDurationSeconds;
  int remainingSeconds;
  bool completed;

  ExerciseInstance({
    required this.id,
    required this.template,
    required this.reps,
    this.completedReps = 0,
    required this.durationPerRepSeconds,
    required this.totalDurationSeconds,
    required this.remainingSeconds,
    this.completed = false,
  });

  /// Complete one rep and update remaining time
  void completeRep() {
    if (completedReps < reps) {
      completedReps++;
      remainingSeconds -= durationPerRepSeconds;
      
      if (remainingSeconds < 0) {
        remainingSeconds = 0;
      }
      
      if (completedReps >= reps) {
        completed = true;
      }
    }
  }
}