import 'package:flutter/material.dart';

class Workday extends StatefulWidget {
  const Workday({super.key});

  @override
  State<Workday> createState() => _WorkdayState();
}

class _WorkdayState extends State<Workday> {
  int selectedDay = 1;
  final List<String> days = ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Day 7'];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       

        // Day Selector
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
          
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
         /*      Text(
                "Select Training Day",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ), */
              SizedBox(height: 20),
            ],
          ),
        ),

        // Start Button
        
      ],
    );
  }
}