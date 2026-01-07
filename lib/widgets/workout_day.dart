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
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: isRest ? null : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Day ${dayNumber}',
                      style: TextStyle(
                        color: isRest ? null : Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      isRest ? "Rest" : "Workout",
                      style: TextStyle(color: isRest ? null : Colors.black54),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isRest ? Colors.grey.shade200 : Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      color: isRest ? Colors.black54 : Colors.black87,
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
