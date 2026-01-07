import 'dart:math';
import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/data/gym_data/activity.dart';
import 'package:fit_go/models/enums.dart';

class UserActivity {
  List<String> schedule;

  Map<int, List<Map<String, dynamic>>> dayActivities = {};

  static const Map<String, int> weekdayIndex = {
    'monday': 0,
    'tuesday': 1,
    'wednesday': 2,
    'thursday': 3,
    'friday': 4,
    'saturday': 5,
    'sunday': 6,
  };

  static const Map<String, Map<String, Map<String, int>>>
      exerciseAllocationByGoal = {
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

  UserActivity({List<String>? scheduleOverride})
      : schedule = scheduleOverride ?? userSetupController.schedule ?? [] {
    _generateActivitiesFor30Days();
  }

  Set<int> _getWorkoutDays() {
    return schedule
        .where((d) => weekdayIndex.containsKey(d))
        .map((d) => weekdayIndex[d]!)
        .toSet();
  }

  void _generateActivitiesFor30Days() {
    final random = Random();
    final intensity = _getIntensity();
    final goalKey = _getGoalKey();
    final allocation = exerciseAllocationByGoal[goalKey]?[intensity];

    if (allocation == null) return;

    final workoutDays = _getWorkoutDays();

    for (int day = 0; day < 30; day++) {
      final dayOfWeek = day % 7;

      if (!workoutDays.contains(dayOfWeek)) continue;

      List<Map<String, dynamic>> dayExercises = [];

      allocation.forEach((muscleType, count) {
        final exercises = activity.where((a) => a.type == muscleType).toList();

        for (int i = 0; i < count && exercises.isNotEmpty; i++) {
          final ex = exercises[random.nextInt(exercises.length)];

          dayExercises.add({
            'id': ex.id,
            'name': ex.name,
            'image': ex.image,
            'type': ex.type,
            'reps': ex.amount,
            'completedReps': 0,
            'durationPerRepSeconds': (ex.time.inSeconds / ex.amount).ceil(),
            'totalDurationSeconds': ex.time.inSeconds,
            'remainingSeconds': ex.time.inSeconds,
            'completed': false,
            'completedAt': null, // ADDED
          });
        }
      });

      dayActivities[day] = dayExercises;
    }
  }


  String _getIntensity() {
    if (schedule.length == 3) return 'low';
    if (schedule.length <= 5) return 'medium';
    return 'high';
  }

  String _getGoalKey() {
    switch (userSetupController.goal) {
      case GoalType.stayFit:
        return 'stayFit';
      case GoalType.gainMuscle:
        return 'gainMuscle';
      case GoalType.loseWeight:
        return 'loseWeight';
      default:
        return 'stayFit';
    }
  }


  List<Map<String, dynamic>> getActivitiesForDay(int dayIndex) {
    if (dayIndex < 0 || dayIndex >= 30) return [];
    return dayActivities[dayIndex] ?? [];
  }

  String getTotalDurationForDay(int dayIndex) {
    final exercises = getActivitiesForDay(dayIndex);
    if (exercises.isEmpty) return 'Rest day';

    final totalSeconds = exercises.fold(
      0,
      (sum, a) => sum + (a['totalDurationSeconds'] as int),
    );

    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;

    if (m == 0) return '${s}s';
    if (s == 0) return '${m}m';
    return '${m}m ${s}s';
  }

  void completeRep(int dayIndex, int activityIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);

    if (activityIndex >= 0 && activityIndex < dayExercises.length) {
      final activity = dayExercises[activityIndex];
      final completedReps = activity['completedReps'] as int;
      final totalReps = activity['reps'] as int;

      if (completedReps < totalReps) {
        activity['completedReps'] = completedReps + 1;
        activity['remainingSeconds'] =
            (totalReps - (completedReps + 1)) *
                (activity['durationPerRepSeconds'] as int);

        if (completedReps + 1 == totalReps) {
          activity['completed'] = true;
          activity['completedAt'] = DateTime.now().toIso8601String();
        }
      }
    }
  }


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


  double getCompletionPercentageForDay(int dayIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);

    if (dayExercises.isEmpty) return 0.0;

    final completed = dayExercises.where((a) => a['completed'] == true).length;
    return (completed / dayExercises.length) * 100;
  }


  bool isDayCompleted(int dayIndex) {
    return getCompletionPercentageForDay(dayIndex) == 100.0;
  }


  int getTotalRepsForDay(int dayIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);
    return dayExercises.fold(
      0,
      (sum, activity) => sum + (activity['reps'] as int),
    );
  }

  int getCompletedRepsForDay(int dayIndex) {
    final dayExercises = getActivitiesForDay(dayIndex);
    return dayExercises.fold(
      0,
      (sum, activity) => sum + (activity['completedReps'] as int),
    );
  }

  /// Get overall progress across all 30 days
  Map<String, dynamic> getOverallProgress() {
    int totalExercises = 0;
    int completedExercises = 0;
    int totalDays = 0;
    int completedDays = 0;

    for (int day = 0; day < 30; day++) {
      final exercises = getActivitiesForDay(day);
      if (exercises.isNotEmpty) {
        totalDays++;
        totalExercises += exercises.length;
        completedExercises +=
            exercises.where((e) => e['completed'] == true).length;

        if (isDayCompleted(day)) {
          completedDays++;
        }
      }
    }

    return {
      'totalExercises': totalExercises,
      'completedExercises': completedExercises,
      'totalDays': totalDays,
      'completedDays': completedDays,
      'exerciseCompletionPercentage': totalExercises > 0
          ? (completedExercises / totalExercises * 100).toStringAsFixed(1)
          : '0.0',
      'dayCompletionPercentage': totalDays > 0
          ? (completedDays / totalDays * 100).toStringAsFixed(1)
          : '0.0',
    };
  }

  /// Get list of all completed days
  List<int> getCompletedDays() {
    List<int> completed = [];
    for (int day = 0; day < 30; day++) {
      if (isDayCompleted(day)) {
        completed.add(day);
      }
    }
    return completed;
  }

  /// Get current streak of completed days
  int getCurrentStreak() {
    int streak = 0;
    for (int day = 29; day >= 0; day--) {
      if (isDayCompleted(day)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'schedule': schedule,
      'dayActivities': dayActivities.map(
        (key, value) => MapEntry(
          key.toString(),
          value.map((activity) => Map<String, dynamic>.from(activity)).toList(),
        ),
      ),
    };
  }

  /// Create from Map (for loading from storage)
  static UserActivity fromMap(Map<String, dynamic> map) {
    final userActivity = UserActivity(
      scheduleOverride: List<String>.from(map['schedule'] ?? []),
    );

    // Override generated activities with saved ones
    if (map['dayActivities'] != null) {
      userActivity.dayActivities.clear();
      (map['dayActivities'] as Map<String, dynamic>).forEach((key, value) {
        userActivity.dayActivities[int.parse(key)] =
            (value as List).map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }

    return userActivity;
  }
}