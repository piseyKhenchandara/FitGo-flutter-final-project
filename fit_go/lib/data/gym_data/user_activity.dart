import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/data/gym_data/activity.dart';
import 'dart:math';

class UserActivity {
  List<String> schedule;
  List<Map<String, dynamic>> activities = [];

  // Exercise allocation based on schedule intensity
  static const Map<String, Map<String, int>> exerciseAllocation = {
    'low': {'arms': 7, 'back': 5, 'legs': 8, 'shoulder': 5},
    'medium': {'arms': 7, 'back': 4, 'legs': 6, 'shoulder': 3},
    'high': {'arms': 5, 'back': 3, 'legs': 5, 'shoulder': 2},
  };

  UserActivity({
    List<String>? scheduleOverride,
  }) : schedule = scheduleOverride ?? userSetupController.schedule ?? [] {
    _generateActivities();
  }

  void _generateActivities() {
    final random = Random();
    String intensity = 'low';

    // Determine intensity based on schedule length
    if (schedule.length == 3) {
      intensity = 'low';
    } else if (schedule.length >= 4 && schedule.length <= 5) {
      intensity = 'medium';
    } else if (schedule.length >= 6) {
      intensity = 'high';
    }

    final allocation = exerciseAllocation[intensity]!;

    // Generate activities based on allocation using data from activity.dart
    allocation.forEach((muscleType, count) {
      // Filter exercises from activity.dart by type
      final exercisesForType = activity
          .where((act) => act.type == muscleType)
          .toList();

      if (exercisesForType.isNotEmpty) {
        for (int i = 0; i < count; i++) {
          final selectedExercise = exercisesForType[random.nextInt(exercisesForType.length)];
          
          // Calculate duration per rep from the exercise's total time and amount
          final totalSeconds = selectedExercise.time.inSeconds;
          final totalReps = selectedExercise.amount;
          final durationPerRepSeconds = (totalSeconds / totalReps).ceil();

          activities.add({
            'id': selectedExercise.id,
            'name': selectedExercise.name,
            'image': selectedExercise.image,
            'type': selectedExercise.type,
            'reps': totalReps,
            'completedReps': 0,
            'durationPerRepSeconds': durationPerRepSeconds,
            'totalDurationSeconds': totalSeconds,
            'remainingSeconds': totalSeconds,
            'completed': false,
          });
        }
      }
    });
  }

  /// Get activities for a specific day
  List<Map<String, dynamic>> getActivitiesForDay(int dayIndex) {
    if (dayIndex < 0 || dayIndex >= schedule.length) {
      return [];
    }
    return activities;
  }

  /// Complete a rep for an activity
  void completeRep(int activityIndex) {
    if (activityIndex >= 0 && activityIndex < activities.length) {
      final activity = activities[activityIndex];
      final completedReps = activity['completedReps'] as int;
      final totalReps = activity['reps'] as int;

      if (completedReps < totalReps) {
        activity['completedReps'] = completedReps + 1;
        activity['remainingSeconds'] = 
            (totalReps - (completedReps + 1)) * (activity['durationPerRepSeconds'] as int);

        if (completedReps + 1 == totalReps) {
          activity['completed'] = true;
        }
      }
    }
  }

  /// Get formatted time remaining (MM:SS format)
  String getFormattedTime(int activityIndex) {
    if (activityIndex < 0 || activityIndex >= activities.length) {
      return '0:00';
    }
    final seconds = activities[activityIndex]['remainingSeconds'] as int;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  /// Get completion percentage
  double getCompletionPercentage() {
    if (activities.isEmpty) return 0.0;
    final completed = activities.where((a) => a['completed'] == true).length;
    return (completed / activities.length) * 100;
  }

  /// Get total reps to complete
  int getTotalReps() {
    return activities.fold(0, (sum, activity) => sum + (activity['reps'] as int));
  }

  /// Get completed reps
  int getCompletedReps() {
    return activities.fold(0, (sum, activity) => sum + (activity['completedReps'] as int));
  }
}

