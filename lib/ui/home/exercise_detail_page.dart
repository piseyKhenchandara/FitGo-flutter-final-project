import 'dart:async';
import 'package:fit_go/data/gym_data/user_activity.dart';
import 'package:flutter/material.dart';

class ExerciseDetailPage extends StatefulWidget {
  final UserActivity userActivity;
  final int dayIndex;
  final int activityIndex;

  const ExerciseDetailPage({
    super.key,
    required this.userActivity,
    required this.dayIndex,
    required this.activityIndex,
  });

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  late Map<String, dynamic> exercise;
  Timer? timer;
  bool isTimerRunning = false;
  int currentExerciseIndex = 0;

  @override
  void initState() {
    super.initState();
    currentExerciseIndex = widget.activityIndex;
    loadExercise();
  }

  void loadExercise() {
    final exercises = widget.userActivity.getActivitiesForDay(widget.dayIndex);
    if (currentExerciseIndex >= 0 && currentExerciseIndex < exercises.length) {
      exercise = exercises[currentExerciseIndex];
    }
  }

  void startTimer() {
    if (isTimerRunning) return;
    
    setState(() {
      isTimerRunning = true;
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (exercise['remainingSeconds'] > 0) {
        setState(() {
          exercise['remainingSeconds']--;
          
          // Auto complete rep when time reaches 0
          if (exercise['remainingSeconds'] == 0) {
            completeRep();
          }
        });
      }
    });
  }

  void pauseTimer() {
    setState(() {
      isTimerRunning = false;
    });
    timer?.cancel();
  }

  void completeRep() {
    widget.userActivity.completeRep(widget.dayIndex, currentExerciseIndex);
    setState(() {
      loadExercise(); // Reload to get updated values
    });
  }

  void goToPreviousExercise() {
    if (currentExerciseIndex > 0) {
      pauseTimer();
      setState(() {
        currentExerciseIndex--;
        loadExercise();
        isTimerRunning = false;
      });
    }
  }

  void goToNextExercise() {
    final exercises = widget.userActivity.getActivitiesForDay(widget.dayIndex);
    if (currentExerciseIndex < exercises.length - 1) {
      pauseTimer();
      setState(() {
        currentExerciseIndex++;
        loadExercise();
        isTimerRunning = false;
      });
    }
  }

  String getFormattedTime() {
    return widget.userActivity.getFormattedTime(widget.dayIndex, currentExerciseIndex);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercises = widget.userActivity.getActivitiesForDay(widget.dayIndex);
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
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
                // Navigation Header with Exercise Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Arrow
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 28),
                      onPressed: currentExerciseIndex > 0 
                          ? goToPreviousExercise 
                          : null,
                      color: currentExerciseIndex > 0 
                          ? Colors.black 
                          : Colors.grey[300],
                    ),
                    
                    // Exercise Name
                    Expanded(
                      child: Text(
                        exercise['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    
                    // Right Arrow
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 28),
                      onPressed: currentExerciseIndex < exercises.length - 1 
                          ? goToNextExercise 
                          : null,
                      color: currentExerciseIndex < exercises.length - 1 
                          ? Colors.black 
                          : Colors.grey[300],
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),

                // Exercise Image
                exercise['image'] != null
                    ? Image.network(
                        exercise['image'],
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => 
                            const Icon(Icons.fitness_center, size: 100, color: Colors.grey),
                      )
                    : const Icon(Icons.fitness_center, size: 100, color: Colors.grey),
                
                const SizedBox(height: 40),

                // Reps Counter (Big Red Number)
                Text(
                  '${exercise['reps'] - exercise['completedReps']}',
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF3B3B),
                    height: 1.0,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // "Timer" Label
                Text(
                  'Timer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 30),

                // Time Display and Start Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Time Display
                    Text(
                      getFormattedTime(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // Start/Pause Button
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00E676).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isTimerRunning ? pauseTimer : startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E676),
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          elevation: 0,
                        ),
                        child: Text(
                          isTimerRunning ? 'Pause' : 'Start',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}