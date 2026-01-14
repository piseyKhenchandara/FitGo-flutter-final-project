import 'dart:async';
import 'package:fit_go/domain/models/workoutplan_model.dart';
import 'package:fit_go/domain/models/exercise_instance.model.dart';
import 'package:fit_go/ui/widgets/appbar.dart';
import 'package:fit_go/ui/widgets/homepage_header.dart';
import 'package:flutter/material.dart';

class ExerciseDetailPage extends StatefulWidget {
  final WorkoutplanModel workoutplanModel;
  final int dayIndex;
  final int activityIndex;

  const ExerciseDetailPage({
    super.key,
    required this.workoutplanModel,
    required this.dayIndex,
    required this.activityIndex,
  });

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  late ExerciseInstance exercise;
  Timer? timer;

  bool isTimerRunning = false;
  int currentExerciseIndex = 0;

  static const int secondsPerRep = 3;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    currentExerciseIndex = widget.activityIndex;
    loadExercise();
  }

  void loadExercise() {
    final dayInstance =
        widget.workoutplanModel.getExercisesForDay(widget.dayIndex);

    if (dayInstance != null &&
        currentExerciseIndex >= 0 &&
        currentExerciseIndex < dayInstance.exercises.length) {
      exercise = dayInstance.exercises[currentExerciseIndex];
      elapsedSeconds = 0;

      int remainingReps = exercise.reps - exercise.completedReps;
      exercise.remainingSeconds = remainingReps * secondsPerRep;
    }
  }

  void startTimer() {
    if (isTimerRunning) return;

    setState(() => isTimerRunning = true);

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (exercise.completedReps >= exercise.reps) {
        pauseTimer();
        return;
      }

      setState(() {
        elapsedSeconds++;
        exercise.remainingSeconds--;

        if (elapsedSeconds % secondsPerRep == 0) {
          completeRep();
        }
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isTimerRunning = false);
  }

  void restartTimer() {
    pauseTimer();
    setState(() {
      elapsedSeconds = 0;
      int remainingReps = exercise.reps - exercise.completedReps;
      exercise.remainingSeconds = remainingReps * secondsPerRep;
    });
  }

  void completeRep() {
    widget.workoutplanModel
        .completeRep(widget.dayIndex, currentExerciseIndex);
    loadExercise();
  }

  void goToPreviousExercise() {
    if (currentExerciseIndex > 0) {
      pauseTimer();
      setState(() {
        currentExerciseIndex--;
        loadExercise();
      });
    }
  }

  void goToNextExercise() {
    final dayInstance =
        widget.workoutplanModel.getExercisesForDay(widget.dayIndex);

    if (dayInstance != null &&
        currentExerciseIndex < dayInstance.exercises.length - 1) {
      pauseTimer();
      setState(() {
        currentExerciseIndex++;
        loadExercise();
      });
    }
  }

  String getFormattedTime() {
    int seconds = exercise.remainingSeconds;
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayInstance =
        widget.workoutplanModel.getExercisesForDay(widget.dayIndex)!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 39, 135),
      appBar: Appbar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 12, 39, 135),
              Color(0xFF1976D2),
              Color(0xFF26C6DA),
            ],
          ),
        ),
        child: Column(
          children: [
            HomepageHeader(
              dayNumber: widget.dayIndex + 1,
              totalExercises: dayInstance.exercises.length,
              duration:
                  widget.workoutplanModel.getTotalDurationForDay(widget.dayIndex),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.chevron_left, size: 28),
                            onPressed:
                                currentExerciseIndex > 0
                                    ? goToPreviousExercise
                                    : null,
                          ),
                          Expanded(
                            child: Text(
                              exercise.template.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.chevron_right, size: 28),
                            onPressed:
                                currentExerciseIndex <
                                        dayInstance.exercises.length - 1
                                    ? goToNextExercise
                                    : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Image.network(
                        exercise.template.image,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.fitness_center,
                                size: 100, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        '${exercise.reps - exercise.completedReps}',
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF3B3B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reps Remaining (3s each)',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getFormattedTime(),
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed:
                                isTimerRunning ? pauseTimer : startTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF00E676),
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            child: Text(
                                isTimerRunning ? 'Pause' : 'Start'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: restartTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            child: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}