import 'dart:math';
import 'package:fit_go/domain/models/user_model.dart';
import 'package:fit_go/domain/models/enums.dart';
import 'package:fit_go/data/gym_data/activity.dart';
import 'package:fit_go/domain/models/workoutplan_model.dart';
import 'package:fit_go/domain/models/day_model.dart';
import 'package:fit_go/domain/models/exercise_instance.model.dart';

class WorkoutplanService {
  // Constants for exercise allocation
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

  /// Generate a 30-day workout plan based on user schedule and goal
  static WorkoutplanModel generate30DayPlan({
    required List<String>? scheduleOverride,
    required List<Day>? weeklyDaysOverride,
  }) {
    final schedule = scheduleOverride ?? user.weeklySchedule ?? [];
    
    // Use provided weekly days or generate new ones
    final weeklyDays = weeklyDaysOverride ?? _generateWeeklySchedule(schedule);
    final monthlyPlan = _generate30DayInstances(weeklyDays);

    return WorkoutplanModel(
      weeklySchedule: weeklyDays,
      monthlyPlan: monthlyPlan,
    );
  }

  /// Generate the weekly template based on schedule
  static List<Day> _generateWeeklySchedule(List<String> schedule) {
    final List<Day> weeklyDays = [];
    final random = Random();
    final intensity = _getIntensity(schedule);
    final goalKey = _getGoalKey();
    final allocation = exerciseAllocationByGoal[goalKey]?[intensity];

    if (allocation == null) {
      return weeklyDays;
    }

    final workoutDays = schedule
        .where((d) => weekdayIndex.containsKey(d))
        .map((d) => weekdayIndex[d]!)
        .toSet();

    for (int dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++) {
      final dayName = _getDayName(dayOfWeek);

      if (workoutDays.contains(dayOfWeek)) {
        // Generate exercises for this day
        List<ExerciseInstance> exercises = [];

        allocation.forEach((muscleType, count) {
          final muscleExercises =
              activity.where((a) => a.type == muscleType).toList();

          for (int i = 0; i < count && muscleExercises.isNotEmpty; i++) {
            final ex =
                muscleExercises[random.nextInt(muscleExercises.length)];
            exercises.add(ExerciseInstance(
              id: ex.id,
              template: ex,
              reps: ex.amount,
              durationPerRepSeconds: (ex.time.inSeconds / ex.amount).ceil(),
              totalDurationSeconds: ex.time.inSeconds,
              remainingSeconds: ex.time.inSeconds,
            ));
          }
        });

        weeklyDays.add(Day(
          dayName: dayName,
          isRestDay: false,
          intensity: intensity,
          exercises: exercises,
        ));
      } else {
        // Rest day
        weeklyDays.add(Day(
          dayName: dayName,
          isRestDay: true,
          exercises: [],
        ));
      }
    }

    return weeklyDays;
  }

  /// Generate 30-day instances from weekly template
  static List<Day> _generate30DayInstances(
    List<Day> weeklyDays,
  ) {
    final List<Day> monthlyPlan = [];
    final startDate = DateTime.now();

    for (int i = 0; i < 30; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final dayOfWeek = currentDate.weekday - 1; // Monday = 0, Sunday = 6

      final dayTemplate = weeklyDays[dayOfWeek % 7];

      // Create exercise instances from template
      final exercises = dayTemplate.exercises;

      monthlyPlan.add(Day(
        dayName: currentDate.toString(),
        isRestDay: dayTemplate.isRestDay,
        exercises: exercises,
      ));
    }

    return monthlyPlan;
  }

  /// Calculate intensity based on schedule length
  static String _getIntensity(List<String> schedule) {
    if (schedule.length == 3) return 'low';
    if (schedule.length <= 5) return 'medium';
    return 'high';
  }

  /// Get goal key from user's goal type
  static String _getGoalKey() {
    switch (user.goal) {
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

  /// Get day name from weekday index
  static String _getDayName(int dayOfWeek) {
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return dayNames[dayOfWeek];
  }
}
