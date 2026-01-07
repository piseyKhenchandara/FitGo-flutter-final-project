import 'package:fit_go/data/gym_data/user_activity.dart';
import 'package:fit_go/ui/home/full_calendar_page.dart';
import 'package:flutter/material.dart';

class CalendarStripWidget extends StatefulWidget {
  const CalendarStripWidget({super.key, required this.userActivity});

  final UserActivity userActivity;

  @override
  State<CalendarStripWidget> createState() => _CalendarStripWidgetState();
}

class _CalendarStripWidgetState extends State<CalendarStripWidget> {
  late ScrollController _scrollController;
  late DateTime startDate;
  late int selectedDayIndex;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    startDate = DateTime.now();
    selectedDayIndex = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  void _scrollToToday() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isScheduledWorkoutDay(DateTime date) {
 
    final dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    final dayName = dayNames[date.weekday - 1];
    
    // Check if this day is in the user's schedule
    return UserActivity.weekdayIndex.containsKey(dayName) &&
        UserActivity.weekdayIndex[dayName] != null &&
        UserActivity.weekdayIndex[dayName]! < (UserActivity.weekdayIndex[dayName] ?? -1) + 1;
  }

  bool _isWorkoutScheduledForDay(DateTime date) {
    
    final dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    final dayName = dayNames[date.weekday - 1];
    

    return UserActivity.weekdayIndex.keys.contains(dayName) && 
        UserActivity.weekdayIndex[dayName] != null;
  }

  bool _isScheduleDay(DateTime date) {
    final dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    final dayName = dayNames[date.weekday - 1];
    

    return UserActivity.weekdayIndex.containsKey(dayName);
  }

  String _getDayOfWeek(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Workout Calendar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Today: ${startDate.toString().split(' ')[0]}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullCalendarPage(
                        userActivity: UserActivity(),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: 60,
            itemBuilder: (context, index) {
              final date = startDate.add(Duration(days: index));
              final dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
              final dayName = dayNames[date.weekday - 1];
              
              // Check if this day is scheduled as a workout day by user
              final isScheduledWorkout = UserActivity.weekdayIndex.containsKey(dayName);
              
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              final isSelected = index == selectedDayIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDayIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 70,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : isScheduledWorkout
                            ? Colors.blue.shade300
                            : Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(12),
                    border: isToday
                        ? Border.all(color: Colors.amber, width: 3)
                        : isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getDayOfWeek(date),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      if (isScheduledWorkout)
                        Icon(
                          Icons.fitness_center,
                          color: isSelected ? Colors.green : Colors.white,
                          size: 18,
                        )
                      else
                        Icon(
                          Icons.local_activity,
                          color: isSelected ? Colors.orange : Colors.white,
                          size: 18,
                        ),
                      const SizedBox(height: 2),
                      Text(
                        isScheduledWorkout ? 'Work' : 'Rest',
                        style: TextStyle(
                          fontSize: 9,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}