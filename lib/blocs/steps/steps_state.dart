import 'package:equatable/equatable.dart';
import '../../models/step_data.dart';

abstract class StepsState extends Equatable {
  const StepsState();

  @override
  List<Object> get props => [];
}

class StepsInitial extends StepsState {}

class StepsLoading extends StepsState {}

class StepsTracking extends StepsState {
  final int currentSteps;
  final int goal;
  final List<StepData> history;

  const StepsTracking({
    required this.currentSteps,
    required this.goal,
    required this.history,
  });

  double get progress => (currentSteps / goal).clamp(0.0, 1.0);

  @override
  List<Object> get props => [currentSteps, goal, history];
}

class StepsError extends StepsState {
  final String message;

  const StepsError(this.message);

  @override
  List<Object> get props => [message];
}
