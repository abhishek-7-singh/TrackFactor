import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'workout_session.g.dart';

@HiveType(typeId: 1)
class WorkoutSession extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final List<ExerciseSet> exercises;

  @HiveField(3)
  final Duration duration;

  @HiveField(4)
  final String? notes;

  const WorkoutSession({
    required this.id,
    required this.date,
    required this.exercises,
    required this.duration,
    this.notes,
  });

  double get totalWeight {
    return exercises.fold(0.0, (sum, exercise) => sum + exercise.totalWeight);
  }

  @override
  List<Object?> get props => [id, date, exercises, duration, notes];
}

@HiveType(typeId: 2)
class ExerciseSet extends Equatable {
  @HiveField(0)
  final String exerciseId;

  @HiveField(1)
  final int sets;

  @HiveField(2)
  final int reps;

  @HiveField(3)
  final double weight;

  @HiveField(4)
  final bool isAssisted;

  const ExerciseSet({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.weight,
    this.isAssisted = false,
  });

  double get totalWeight => sets * reps * weight;

  @override
  List<Object> get props => [exerciseId, sets, reps, weight, isAssisted];
}
