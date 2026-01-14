import 'package:uuid/uuid.dart';


class ActivityModel{
  final String id;  
  final String image;
  final String name;
  final String type;
  final int amount;
  final Duration time;

  ActivityModel({
    String? id,
    required this.image,
    required this.name,
    required this.type,
    required this.time,
    required this.amount,
  }): id = id ?? Uuid().v4();
}