import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'step_data.g.dart';

@HiveType(typeId: 4)
class StepData extends Equatable {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int steps;

  @HiveField(2)
  final double distance;

  @HiveField(3)
  final int calories;

  const StepData({
    required this.date,
    required this.steps,
    required this.distance,
    required this.calories,
  });

  @override
  List<Object> get props => [date, steps, distance, calories];
}
