class WorkoutDay {
  final String name;
  final List<String> muscleGroups;
  final Map<String, int > exerciseCounts;

  const WorkoutDay({
    required this.name,
    required this.muscleGroups,
    required this.exerciseCounts
  });
}
