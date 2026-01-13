import 'package:fit_go/domain/models/workoutplan_model.dart';
import 'package:flutter/material.dart';
import 'package:fit_go/ui/widgets/appbar.dart';

class FullCalendarPage extends StatefulWidget {
  final WorkoutplanModel workoutplanModel;

  const FullCalendarPage({
    super.key,
    required this.workoutplanModel,
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
    return widget.workoutplanModel.weeklySchedule.contains(dayName);
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
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
    final monthName = _getMonthName(displayMonth.month);

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
            // Header with title and navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workout Schedule',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$monthName ${displayMonth.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Month Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          displayMonth = DateTime(displayMonth.year, displayMonth.month - 1);
                        });
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      splashColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "${displayMonth.month.toString().padLeft(2, '0')}/${displayMonth.year}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          displayMonth = DateTime(displayMonth.year, displayMonth.month + 1);
                        });
                      },
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                      splashColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Day headers with better styling
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _DayHeader('Mon'),
                  _DayHeader('Tue'),
                  _DayHeader('Wed'),
                  _DayHeader('Thu'),
                  _DayHeader('Fri'),
                  _DayHeader('Sat'),
                  _DayHeader('Sun'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Calendar Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: calendarDays.length,
                  itemBuilder: (context, index) {
                    final date = calendarDays[index];
                    final isCurrentMonth = date.month == displayMonth.month;
                    final isTodayDate = date.year == isToday.year &&
                        date.month == isToday.month &&
                        date.day == isToday.day;
                    final isWorkoutDay = _isScheduledWorkoutDay(date);

                    return _CalendarDayCard(
                      date: date,
                      isCurrentMonth: isCurrentMonth,
                      isTodayDate: isTodayDate,
                      isWorkoutDay: isWorkoutDay,
                    );
                  },
                ),
              ),
            ),

            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _LegendItem(
                      color: Color(0xFF42A5F5),
                      icon: Icons.fitness_center,
                      label: 'Workout',
                    ),
                    Container(
                      height: 35,
                      width: 1.5,
                      color: Colors.white.withOpacity(0.25),
                    ),
                    _LegendItem(
                      color: Color.fromARGB(255, 145, 158, 171),
                      icon: Icons.hotel,
                      label: 'Rest',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

class _DayHeader extends StatelessWidget {
  final String day;

  const _DayHeader(this.day);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _CalendarDayCard extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isTodayDate;
  final bool isWorkoutDay;

  const _CalendarDayCard({
    required this.date,
    required this.isCurrentMonth,
    required this.isTodayDate,
    required this.isWorkoutDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: !isCurrentMonth
            ? Colors.grey.shade800
            : isWorkoutDay
                ? Color(0xFF42A5F5)
                : Colors.grey.shade600,
        gradient: !isCurrentMonth || !isWorkoutDay
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF42A5F5),
                  Color(0xFF1E88E5),
                ],
              ),
        borderRadius: BorderRadius.circular(14),
        border: isTodayDate
            ? Border.all(color: Colors.amber, width: 3)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isCurrentMonth ? Colors.white : Colors.grey.shade400,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;

  const _LegendItem({
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}