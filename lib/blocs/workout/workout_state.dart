import 'package:equatable/equatable.dart';
import '../../models/exercise.dart';
import '../../models/workout_session.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => []; // ✅ Fixed: Changed to List<Object?> to allow nullable objects
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<Exercise> exercises;
  final List<WorkoutSession> history;
  final WorkoutSession? currentSession; // This is nullable

  const WorkoutLoaded({
    required this.exercises,
    required this.history,
    this.currentSession,
  });

  @override
  List<Object?> get props => [exercises, history, currentSession]; // ✅ Now matches parent class
}

class WorkoutInProgress extends WorkoutState {
  final List<ExerciseSet> currentExercises;
  final DateTime startTime;

  const WorkoutInProgress({
    required this.currentExercises,
    required this.startTime,
  });

  @override
  List<Object> get props => [currentExercises, startTime]; // Non-nullable objects
}

class WorkoutCompleted extends WorkoutState {
  final WorkoutSession session;

  const WorkoutCompleted(this.session);

  @override
  List<Object> get props => [session]; // Non-nullable object
}

class WorkoutError extends WorkoutState {
  final String message;

  const WorkoutError(this.message);

  @override
  List<Object> get props => [message]; // Non-nullable object
}
