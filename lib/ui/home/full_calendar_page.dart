import 'package:flutter/material.dart';
import 'package:fit_go/data/gym_data/user_activity.dart';
import 'package:fit_go/widgets/appbar.dart';

class FullCalendarPage extends StatefulWidget {
  final UserActivity userActivity;

  const FullCalendarPage({
    super.key,
    required this.userActivity,
  });

  @override
  State<FullCalendarPage> createState() => _FullCalendarPageState();
}

class _FullCalendarPageState extends State<FullCalendarPage> {
  late DateTime displayMonth;

  @override
  void initState() {
    super.initState();
    displayMonth = DateTime.now();
  }

  bool _isScheduledWorkoutDay(DateTime date) {
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    final dayName = dayNames[date.weekday - 1];
    return UserActivity.weekdayIndex.containsKey(dayName);
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = last.day;
    return List.generate(
        daysInMonth, (index) => DateTime(month.year, month.month, index + 1));
  }

  List<DateTime> _getCalendarDays(DateTime month) {
    final daysInMonth = _getDaysInMonth(month);
    final firstDay = daysInMonth.first;
    final firstWeekday = firstDay.weekday - 1;

    final previousMonthDays = _getDaysInMonth(DateTime(month.year, month.month - 1, 1));
    final emptyDays = previousMonthDays.sublist(previousMonthDays.length - firstWeekday);

    return [...emptyDays, ...daysInMonth];
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = _getCalendarDays(displayMonth);
    final isToday = DateTime.now();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 39, 135),
      appBar: Appbar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 12, 39, 135),
              Color(0xFF1976D2),
              Color(0xFF26C6DA),
            ],
          ),
        ),
        child: Column(
          children: [
            // Month Navigation
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        displayMonth = DateTime(displayMonth.year, displayMonth.month - 1);
                      });
                    },
                    icon: const Icon(Icons.arrow_left, color: Colors.white, size: 28),
                  ),
                  Text(
                    "${displayMonth.year}-${displayMonth.month.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        displayMonth = DateTime(displayMonth.year, displayMonth.month + 1);
                      });
                    },
                    icon: const Icon(Icons.arrow_right, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),

            // Day headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text('Mon', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Tue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Wed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Thu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Fri', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Sat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Sun', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Calendar Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: calendarDays.length,
                itemBuilder: (context, index) {
                  final date = calendarDays[index];
                  final isCurrentMonth = date.month == displayMonth.month;
                  final isTodayDate = date.year == isToday.year &&
                      date.month == isToday.month &&
                      date.day == isToday.day;
                  final isWorkoutDay = _isScheduledWorkoutDay(date);

                  return Container(
                    decoration: BoxDecoration(
                      color: isCurrentMonth
                          ? (isWorkoutDay ? Colors.blue.shade300 : Colors.grey.shade600)
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                      border: isTodayDate
                          ? Border.all(color: Colors.amber, width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCurrentMonth ? Colors.white : Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isCurrentMonth && isWorkoutDay)
                          const Icon(Icons.fitness_center, color: Colors.white, size: 16)
                        else if (isCurrentMonth)
                          const Icon(Icons.local_activity, color: Colors.white, size: 16),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Legend
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _LegendItem(
                    color: Colors.blue.shade300,
                    label: 'Workout Days',
                  ),
                  _LegendItem(
                    color: Colors.grey.shade600,
                    label: 'Rest Days',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}