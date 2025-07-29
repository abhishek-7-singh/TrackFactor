import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/exercise_repository.dart';
import '../../models/workout_session.dart';
import 'workout_event.dart';
import 'workout_state.dart';
import '../../utils/helpers.dart'; // ✅ Add this import

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final ExerciseRepository exerciseRepository;
  List<ExerciseSet> _currentExercises = [];
  DateTime? _workoutStartTime;

  WorkoutBloc({required this.exerciseRepository}) : super(WorkoutInitial()) {
    on<LoadExercises>(_onLoadExercises);
    on<LoadWorkoutHistory>(_onLoadWorkoutHistory);
    on<StartWorkout>(_onStartWorkout);
    on<LogExercise>(_onLogExercise);
    on<CompleteWorkout>(_onCompleteWorkout);
  }

  Future<void> _onLoadExercises(LoadExercises event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    try {
      final exercises = await exerciseRepository.getExercises();
      final history = await exerciseRepository.getWorkoutHistory();
      emit(WorkoutLoaded(exercises: exercises, history: history));
    } catch (e) {
      emit(WorkoutError('Failed to load exercises: $e'));
    }
  }

  Future<void> _onLoadWorkoutHistory(LoadWorkoutHistory event, Emitter<WorkoutState> emit) async {
    try {
      final history = await exerciseRepository.getWorkoutHistory();
      if (state is WorkoutLoaded) {
        final currentState = state as WorkoutLoaded;
        emit(WorkoutLoaded(
          exercises: currentState.exercises,
          history: history,
          currentSession: currentState.currentSession,
        ));
      }
    } catch (e) {
      emit(WorkoutError('Failed to load workout history: $e'));
    }
  }

  void _onStartWorkout(StartWorkout event, Emitter<WorkoutState> emit) {
    _currentExercises.clear();
    _workoutStartTime = DateTime.now();
    emit(WorkoutInProgress(
      currentExercises: List.from(_currentExercises),
      startTime: _workoutStartTime!,
    ));
  }

  void _onLogExercise(LogExercise event, Emitter<WorkoutState> emit) {
    final exerciseSet = ExerciseSet(
      exerciseId: event.exercise.id,
      sets: event.sets,
      reps: event.reps,
      weight: event.weight,
      isAssisted: event.isAssisted,
    );

    _currentExercises.add(exerciseSet);

    emit(WorkoutInProgress(
      currentExercises: List.from(_currentExercises),
      startTime: _workoutStartTime!,
    ));
  }

  Future<void> _onCompleteWorkout(CompleteWorkout event, Emitter<WorkoutState> emit) async {
    if (_workoutStartTime == null) return;

    final session = WorkoutSession(
      id: Helpers.generateId(), // ✅ Fixed: Call Helpers.generateId()
      date: _workoutStartTime!,
      exercises: List.from(_currentExercises),
      duration: DateTime.now().difference(_workoutStartTime!),
      notes: event.notes,
    );

    try {
      await exerciseRepository.saveWorkoutSession(session);
      emit(WorkoutCompleted(session));

      // Reset state
      _currentExercises.clear();
      _workoutStartTime = null;
    } catch (e) {
      emit(WorkoutError('Failed to save workout: $e'));
    }
  }
}
