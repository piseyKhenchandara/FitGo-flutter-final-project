import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/data/gym_data/activity.dart';
import 'dart:math';

class UserActivity {
  List<String> schedule;
  Map<int, List<Map<String, dynamic>>> dayActivities = {}; // Activities for each day (0-29)

  // Exercise allocation based on schedule intensity
  static const Map<String, Map<String, int>> exerciseAllocation = {
    'low': {'arms': 7, 'back': 5, 'legs': 8, 'shoulder': 5},
    'medium': {'arms': 7, 'back': 4, 'legs': 6, 'shoulder': 3},
    'high': {'arms': 5, 'back': 3, 'legs': 5, 'shoulder': 2},
  };

  UserActivity({
    List<String>? scheduleOverride,
  }) : schedule = scheduleOverride ?? userSetupController.schedule ?? [] {
    _generateActivitiesFor30Days();
  }

  void _generateActivitiesFor30Days() {
    final random = Random();
    String intensity = _getIntensity();

    // Generate random activities for each of the 30 days
    for (int day = 0; day < 30; day++) {
      List<Map<String, dynamic>> dayExercises = [];

      // Only generate activities for workout days (within schedule length)
      if (day < schedule.length) {
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

              dayExercises.add({
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

      dayActivities[day] = dayExercises;
    }
  }

  String _getIntensity() {
    if (schedule.length == 3) {
      return 'low';
    } else if (schedule.length >= 4 && schedule.length <= 5) {
      return 'medium';
    } else {
      return 'high';
    }
  }

  /// Get activities for a specific day (0-29)
  List<Map<String, dynamic>> getActivitiesForDay(int dayIndex) {
    if (dayIndex < 0 || dayIndex >= 30) {
      return [];
    }
    return dayActivities[dayIndex] ?? [];
  }

  /// Get total duration for a specific day (formatted string)
  String getTotalDurationForDay(int dayIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);
    
    if (dayExercises.isEmpty) {
      return 'Rest Day';
    }

    final totalSeconds = dayExercises.fold<int>(
      0,
      (sum, activity) => sum + (activity['totalDurationSeconds'] as int),
    );

    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    
    if (minutes == 0) {
      return '${seconds}s';
    } else if (seconds == 0) {
      return '${minutes}m';
    } else {
      return '${minutes}m ${seconds}s';
    }
  }

  /// Complete a rep for an activity on a specific day
  void completeRep(int dayIndex, int activityIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);
    
    if (activityIndex >= 0 && activityIndex < dayExercises.length) {
      final activity = dayExercises[activityIndex];
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

  /// Get formatted time remaining for an activity (MM:SS format)
  String getFormattedTime(int dayIndex, int activityIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);
    
    if (activityIndex < 0 || activityIndex >= dayExercises.length) {
      return '0:00';
    }
    
    final seconds = dayExercises[activityIndex]['remainingSeconds'] as int;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  /// Get completion percentage for a specific day
  double getCompletionPercentageForDay(int dayIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);
    
    if (dayExercises.isEmpty) return 0.0;
    
    final completed = dayExercises.where((a) => a['completed'] == true).length;
    return (completed / dayExercises.length) * 100;
  }

  /// Get total reps to complete for a specific day
  int getTotalRepsForDay(int dayIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);
    return dayExercises.fold(0, (sum, activity) => sum + (activity['reps'] as int));
  }

  /// Get completed reps for a specific day
  int getCompletedRepsForDay(int dayIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);
    return dayExercises.fold(0, (sum, activity) => sum + (activity['completedReps'] as int));
  }
}

