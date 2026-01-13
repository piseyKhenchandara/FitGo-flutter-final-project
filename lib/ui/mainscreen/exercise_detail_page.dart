import 'dart:async';
import 'package:fit_go/data/gym_data/user_activity.dart';
import 'package:fit_go/ui/widgets/appbar.dart';
import 'package:fit_go/ui/widgets/homepage_header.dart';
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
  int originalDuration = 0;
  static const int secondsPerRep = 3; // 3 seconds per rep

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
      
      // Calculate total duration: remaining reps × 3 seconds
      int remainingReps = (exercise['reps'] ?? 0) - (exercise['completedReps'] ?? 0);
      originalDuration = remainingReps * secondsPerRep;
      
      // Set remainingSeconds if not already set
      if (exercise['remainingSeconds'] == null || exercise['remainingSeconds'] == 0) {
        exercise['remainingSeconds'] = originalDuration;
      }
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
          
          // Check if we completed a rep (every 3 seconds)
          int remainingReps = (exercise['reps'] ?? 0) - (exercise['completedReps'] ?? 0);
          int expectedSeconds = remainingReps * secondsPerRep;
          
          // If we've counted down 3 seconds, complete a rep
          if (exercise['remainingSeconds'] > 0 && 
              exercise['remainingSeconds'] == expectedSeconds - secondsPerRep) {
            completeRep();
          }
          
          // Auto complete when time reaches 0
          if (exercise['remainingSeconds'] == 0) {
            completeRep();
            pauseTimer();
          }
        });
      }
    });
  }

  void restartTimer() {
    pauseTimer();
    setState(() {
      // Recalculate duration based on remaining reps
      int remainingReps = (exercise['reps'] ?? 0) - (exercise['completedReps'] ?? 0);
      originalDuration = remainingReps * secondsPerRep;
      exercise['remainingSeconds'] = originalDuration;
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
    int seconds = exercise['remainingSeconds'] ?? 0;
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
    final exercises = widget.userActivity.getActivitiesForDay(widget.dayIndex);
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 39, 135),
      appBar: Appbar(),
      body: Container(
        decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 12, 39, 135), // Purple
                    Color(0xFF1976D2), // Blue
                    Color(0xFF26C6DA), // Cyan
                  ],
                ),
              ),
        child: Column(
          children: [
            
            HomepageHeader(
              dayNumber: widget.dayIndex + 1,
              totalExercises: exercises.length,
              duration: widget.userActivity.getTotalDurationForDay(widget.dayIndex),
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
                          
                         
                          Expanded(
                            child: Text(
                              exercise['name'] ?? 'Exercise',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          
                          
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

                     
                      Text(
                        '${(exercise['reps'] ?? 0) - (exercise['completedReps'] ?? 0)}',
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF3B3B),
                          height: 1.0,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
            
                      Text(
                        'Reps Remaining (3s each)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 30),

                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        
                          Text(
                            getFormattedTime(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          
                          const SizedBox(width: 20),
                          
                        
                          Row(
                            children: [
                              ElevatedButton(
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
                              
                              const SizedBox(width: 10),
                              
                              ElevatedButton(
                                onPressed: restartTimer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  elevation: 0,
                                ),
                                child: const Icon(
                                  Icons.refresh,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
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