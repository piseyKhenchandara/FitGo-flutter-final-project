import 'package:flutter/material.dart';
import 'package:fit_go/data/gym_data/user_activity.dart';

class WorkoutDay extends StatefulWidget {
  const WorkoutDay({super.key});

  @override
  State<WorkoutDay> createState() => _WorkoutDayState();
}

class _WorkoutDayState extends State<WorkoutDay> {
  late UserActivity userActivity;
  int selectedDay = 1;

  @override
  void initState() {
    super.initState();
    userActivity = UserActivity();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      itemBuilder: (context, index) {
        final int dayNumber = index + 1;

        final dayActivities =
            userActivity.getActivitiesForDay(index);
        final bool isRest = dayActivities.isEmpty;
        final bool isSelected = selectedDay == dayNumber;
        final String duration =
            userActivity.getTotalDurationForDay(index);

        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            setState(() => selectedDay = dayNumber);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Colors.blue.shade500,
                        Colors.blue.shade400
                      ],
                    )
                  : isRest
                      ? LinearGradient(
                          colors: [
                            Colors.grey.shade400,
                            Colors.grey.shade300
                          ],
                        )
                      : null,
              color: isSelected || isRest ? null : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color:
                    isSelected ? Colors.blue.shade500 : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? Colors.blue.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: isSelected ? 10 : 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Day info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day $dayNumber',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : isRest
                                ? Colors.grey.shade800
                                : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isRest ? 'Rest Day' : 'Workout Day',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : isRest
                                ? Colors.grey.shade700
                                : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                /// Duration
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected || isRest
                        ? Colors.white
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : isRest
                              ? Colors.grey.shade800
                              : Colors.blue.shade600,
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
