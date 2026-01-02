import 'package:flutter/material.dart';

class AvgWeight {
  final double avgWeight;
  final String comment;
  final Color color;
  
  AvgWeight({
    required this.avgWeight, 
    required this.comment,
    required this.color,
  });
}

List<AvgWeight> avgList = [
  AvgWeight(
    avgWeight: 18.5, 
    comment: "Underweight - We suggest you: Gain Muscle", // < 18.5
    color: Colors.blue
  ),
  AvgWeight(
    avgWeight: 24.9, 
    comment: "Healthy weight - We suggest you: Stay Fit", // 18.5 - 24.9
    color: Colors.green
  ),
  AvgWeight(
    avgWeight: 29.9, 
    comment: "Overweight - We suggest you: Lose Weight", // 25 - 29.9
    color: Colors.orange
  ),
  AvgWeight(
    avgWeight: 30, 
    comment: "Obese - We suggest you: Lose Weight", // 30+
    color: Colors.red
  ),
];