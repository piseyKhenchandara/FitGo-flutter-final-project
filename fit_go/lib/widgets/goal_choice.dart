import 'package:fit_go/models/enums.dart';
import 'package:flutter/material.dart';

class GoalChoice extends StatelessWidget {
  const GoalChoice({
    super.key,
    required this.text,
    required this.selectedGoal,
    required this.onPress,
    required this.goalType,
  });

  final String text;
  final GoalType goalType;
  final GoalType? selectedGoal;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(
          decoration: TextDecoration.underline,
          height: 1.5,
          fontWeight: FontWeight.bold,
          color: selectedGoal == goalType
              ? Colors.blue
              : Colors.black,
        ),
      ),
    );
  }
}
