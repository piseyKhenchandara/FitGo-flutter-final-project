import 'package:uuid/uuid.dart';


class ActivityModel{
  final String id = Uuid().v4();  
  final String image;
  final String name;
  final String type;
  final int amount;
  final bool isCompleted;
  final Duration time;

  ActivityModel({
    required this.image,
    required this.name,
    required this.type,
    required this.time,
    required this.amount,
  }) : isCompleted = false;
}