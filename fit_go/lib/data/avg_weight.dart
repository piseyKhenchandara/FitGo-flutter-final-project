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
    avgWeight: 18.4, 
    comment: "Underweight",
    color: Colors.yellow
  ),
  AvgWeight(
    avgWeight: 24.9, 
    comment: "Healthy weight",
    color: Colors.green
  ),
  AvgWeight(
    avgWeight: 25, 
    comment: "Overweight",
    color: Colors.yellow

  ),
  AvgWeight(
    avgWeight: 30, 
    comment: "Obese",
    color: Colors.red
  ),

];