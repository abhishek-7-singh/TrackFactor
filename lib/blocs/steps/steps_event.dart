import 'package:equatable/equatable.dart';

abstract class StepsEvent extends Equatable {
  const StepsEvent();

  @override
  List<Object> get props => [];
}

class StartStepTracking extends StepsEvent {}

class StopStepTracking extends StepsEvent {}

class UpdateStepCount extends StepsEvent {
  final int steps;

  const UpdateStepCount(this.steps);

  @override
  List<Object> get props => [steps];
}

class LoadStepHistory extends StepsEvent {}
