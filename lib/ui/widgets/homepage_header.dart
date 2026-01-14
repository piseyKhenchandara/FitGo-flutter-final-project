import 'package:flutter/material.dart';

class HomepageHeader extends StatelessWidget {
  const HomepageHeader({
    super.key,
    required this.dayNumber,
    required this.duration,
    this.totalExercises = 0,
    this.completedExercises = 0,
  });

  final int dayNumber;
  final String duration;
  final int totalExercises;
  final int completedExercises;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          
          SizedBox(height: 20),
          
        
          Text(
            'Day $dayNumber',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Total exercises
              _buildStatCard(
                icon: Icons.fitness_center,
                label: 'Exercises',
                value: '$totalExercises',
              ),
              
              SizedBox(width: 20,),
              // Duration
              _buildStatCard(
                icon: Icons.timer,
                label: 'Duration',
                value: duration,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
