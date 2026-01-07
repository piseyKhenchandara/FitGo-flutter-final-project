import 'dart:async';
import 'package:fit_go/ui/home/exercise_detail_page.dart';
import 'package:fit_go/widgets/appbar.dart';
import 'package:fit_go/widgets/homepage_header.dart';
import 'package:fit_go/widgets/rest_day_widget.dart';
import 'package:flutter/material.dart';
import 'package:fit_go/data/gym_data/user_activity.dart';


class WorkoutDetailPage extends StatelessWidget {
  final int dayNumber;
  final List<Map<String, dynamic>> exercises;
  final String duration;
  final UserActivity userActivity;
  final int dayIndex;

  const WorkoutDetailPage({
    super.key,
    required this.dayNumber,
    required this.exercises,
    required this.duration,
    required this.userActivity,
    required this.dayIndex,
  });

  @override
Widget build(BuildContext context) {
  return Scaffold(
    
    appBar: Appbar(),
    body: exercises.isEmpty
        ? RestDayWidget()
        : Container(
            color: Colors.lightBlue,
            
            child: Column(
              children: [
                // Header with back button and day info
                HomepageHeader(
                  dayNumber: dayNumber,
                  duration: duration,
                ),
        
                
                SizedBox(height: 16),
                // Exercise list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExerciseDetailPage(
                                  userActivity: userActivity,
                                  dayIndex: dayIndex,
                                  activityIndex: index,
                                ),
                              ),
                            );
                          },
                          leading: exercise['image'] != null
                              ? Image.network(
                                  exercise['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.fitness_center);
                                  },
                                )
                              : const Icon(Icons.fitness_center),
                          title: Text(
                            exercise['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Reps: ${exercise['reps']} | Type: ${exercise['type']}',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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