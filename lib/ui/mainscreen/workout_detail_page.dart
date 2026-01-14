import 'package:fit_go/domain/models/workoutplan_model.dart';
import 'package:fit_go/ui/mainscreen/exercise_detail_page.dart';
import 'package:fit_go/ui/widgets/appbar.dart';
import 'package:fit_go/ui/widgets/homepage_header.dart';
import 'package:fit_go/ui/widgets/rest_day_widget.dart';
import 'package:flutter/material.dart';


class WorkoutDetailPage extends StatefulWidget {
  final int dayNumber;
  final int dayIndex;
  final WorkoutplanModel workoutplanModel;

  const WorkoutDetailPage({
    super.key,
    required this.dayNumber,
    required this.dayIndex,
    required this.workoutplanModel,
  });

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dayInstance = widget.workoutplanModel.getExercisesForDay(widget.dayIndex);
    final isRestDay = dayInstance == null || dayInstance.isRestDay || dayInstance.exercises.isEmpty;
    final duration = widget.workoutplanModel.getTotalDurationForDay(widget.dayIndex);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 39, 135),
      appBar: Appbar(),
      body: isRestDay
          ? RestDayWidget()
          : Container(
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
                  // Header with back button and day info
                  HomepageHeader(
                    dayNumber: widget.dayNumber,
                    duration: duration,
                    totalExercises: dayInstance.exercises.length,
                  ),
        
                
                SizedBox(height: 16),
                // Exercise list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: dayInstance.exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = dayInstance.exercises[index];
                      final isCompleted = exercise.completed;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: isCompleted ? Colors.green.shade100 : null,
                        child: ListTile(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExerciseDetailPage(
                                  workoutplanModel: widget.workoutplanModel,
                                  dayIndex: widget.dayIndex,
                                  activityIndex: index,
                                ),
                              ),
                            );
                            // Refresh the page when returning from exercise detail
                            _refreshPage();
                          },
                          leading: Image.network(
                                  exercise.template.image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.fitness_center);
                                  },
                                ),
                          title: Text(
                            exercise.template.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Reps: ${exercise.completedReps}/${exercise.reps} | Type: ${exercise.template.type}',
                          ),
                          trailing: isCompleted 
                              ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
                              : const Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}