import 'package:fit_go/data/gym_data/user_activity.dart';
import 'package:fit_go/ui/home/workout_detail_page.dart';
import 'package:flutter/material.dart';

class WorkoutDay extends StatefulWidget {
  const WorkoutDay({super.key});

  @override
  State<WorkoutDay> createState() => _WorkoutDayState();
}

class _WorkoutDayState extends State<WorkoutDay> {
  late UserActivity userActivity;
  int isSelected = 1;

  @override
  void initState() {
    super.initState();
    userActivity = UserActivity();
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 30,
      itemBuilder: (context, index) {
        final dayNumber = index + 1;
        final dayActivities = userActivity.getActivitiesForDay(index);
        final isRest = dayActivities.isEmpty;
        final String duration = userActivity.getTotalDurationForDay(index);

        return InkWell(
          onTap: () {
            setState(() {
              isSelected = dayNumber;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetailPage(
                  dayNumber: dayNumber,
                  exercises: dayActivities,
                  duration: duration,
                  userActivity: userActivity,
                  dayIndex: index,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 12),
            decoration: BoxDecoration(
              gradient: isRest
                  ? null
                  : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.5),
                      ],
                    ),
              color: isRest ? Colors.white.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3), 
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), 
                  blurRadius: 8, // Added missing properties
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( 
                  child: ListTile(
                    contentPadding: EdgeInsets.zero, 
                    leading: Icon(
                      Icons.fitness_center,
                      color: isRest ? Colors.grey : Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      'Day ${dayNumber}',
                      style: TextStyle(
                        color: isRest ? Colors.grey : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      isRest ? "Rest" : "Workout",
                      style: TextStyle(
                        color: isRest ? Colors.grey : Colors.white70,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isRest ? Colors.grey.shade200 : Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.8)),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      color: isRest ? Colors.black54 : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}