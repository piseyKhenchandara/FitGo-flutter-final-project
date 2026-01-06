import 'dart:async';
import 'package:fit_go/ui/home/exercise_detail_page.dart';
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
      appBar: AppBar(
        title: Text('Day $dayNumber Workout'),
        backgroundColor: Colors.blue[400],
      ),
      body: exercises.isEmpty
          ? Center(
              child: Text(
                'Rest Day',
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () {
                      // Navigate to Exercise Detail Page
                      print('navigate');
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
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
    );
  }
}