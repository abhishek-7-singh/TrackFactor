import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/steps_repository.dart';
import 'steps_event.dart';
import 'steps_state.dart';

class StepsBloc extends Bloc<StepsEvent, StepsState> {
  final StepsRepository stepsRepository;
  StreamSubscription? _stepSubscription;

  StepsBloc({required this.stepsRepository}) : super(StepsInitial()) {
    on<StartStepTracking>(_onStartStepTracking);
    on<StopStepTracking>(_onStopStepTracking);
    on<UpdateStepCount>(_onUpdateStepCount);
    on<LoadStepHistory>(_onLoadStepHistory);
  }

  Future<void> _onStartStepTracking(StartStepTracking event, Emitter<StepsState> emit) async {
    emit(StepsLoading());
    try {
      final history = await stepsRepository.getStepHistory();
      emit(StepsTracking(currentSteps: 0, goal: 10000, history: history));

      _stepSubscription = stepsRepository.stepStream.listen((steps) {
        add(UpdateStepCount(steps));
      });
    } catch (e) {
      emit(StepsError('Failed to start step tracking: $e'));
    }
  }

  void _onStopStepTracking(StopStepTracking event, Emitter<StepsState> emit) {
    _stepSubscription?.cancel();
    emit(StepsInitial());
  }

  void _onUpdateStepCount(UpdateStepCount event, Emitter<StepsState> emit) {
    if (state is StepsTracking) {
      final currentState = state as StepsTracking;
      emit(StepsTracking(
        currentSteps: event.steps,
        goal: currentState.goal,
        history: currentState.history,
      ));
    }
  }

  Future<void> _onLoadStepHistory(LoadStepHistory event, Emitter<StepsState> emit) async {
    try {
      final history = await stepsRepository.getStepHistory();
      if (state is StepsTracking) {
        final currentState = state as StepsTracking;
        emit(StepsTracking(
          currentSteps: currentState.currentSteps,
          goal: currentState.goal,
          history: history,
        ));
      }
    } catch (e) {
      emit(StepsError('Failed to load step history: $e'));
    }
  }

  @override
  Future<void> close() {
    _stepSubscription?.cancel();
    return super.close();
  }
}
