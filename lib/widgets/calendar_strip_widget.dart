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
    return widget.userActivity.schedule.contains(dayName);
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
              
              // Check if this day is scheduled as a workout day by user
              final isScheduledWorkout = _isScheduledWorkoutDay(date);
              
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
                    // Workout day: vibrant blue gradient
                    // Rest day: muted gray
                    // Selected: bright white
                    color: isSelected
                        ? Colors.white
                        : isScheduledWorkout
                            ? Color(0xFF42A5F5)
                            : Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(12),
                    gradient: isSelected
                        ? null
                        : isScheduledWorkout
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF42A5F5),
                                  Color(0xFF1E88E5),
                                ],
                              )
                            : null,
                    border: isToday
                        ? Border.all(color: Colors.amber, width: 3)
                        : isSelected
                            ? Border.all(color: Color(0xFF1976D2), width: 2)
                            : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
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
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Color(0xFF1976D2) : Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Color(0xFF1976D2) : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isScheduledWorkout)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFF4CAF50) : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.fitness_center,
                                color: isSelected ? Colors.white : Colors.white,
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Work',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFFFA726) : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.hotel,
                                color: isSelected ? Colors.white : Colors.white,
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Rest',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.white,
                                ),
                              ),
                            ],
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