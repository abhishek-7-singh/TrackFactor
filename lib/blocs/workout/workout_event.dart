import 'package:equatable/equatable.dart';
import '../../models/exercise.dart';
import '../../models/workout_session.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object> get props => [];
}

class LoadExercises extends WorkoutEvent {}

class LoadWorkoutHistory extends WorkoutEvent {}

class StartWorkout extends WorkoutEvent {}

class LogExercise extends WorkoutEvent {
  final Exercise exercise;
  final int sets;
  final int reps;
  final double weight;
  final bool isAssisted;

  const LogExercise({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.weight,
    this.isAssisted = false,
  });

  @override
  List<Object> get props => [exercise, sets, reps, weight, isAssisted];
}

class CompleteWorkout extends WorkoutEvent {
  final String notes;

  const CompleteWorkout({this.notes = ''});

  @override
  List<Object> get props => [notes];
}
