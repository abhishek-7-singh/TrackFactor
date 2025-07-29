import 'package:equatable/equatable.dart';
import '../../models/food_entry.dart';

abstract class NutritionState extends Equatable {
  const NutritionState();

  @override
  List<Object> get props => [];
}

class NutritionInitial extends NutritionState {}

class NutritionLoading extends NutritionState {}

class NutritionLoaded extends NutritionState {
  final List<FoodEntry> foodEntries;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  const NutritionLoaded({
    required this.foodEntries,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  @override
  List<Object> get props => [foodEntries, totalCalories, totalProtein, totalCarbs, totalFat];
}

class FoodSearchResults extends NutritionState {
  final List<FoodEntry> results;

  const FoodSearchResults(this.results);

  @override
  List<Object> get props => [results];
}

class NutritionError extends NutritionState {
  final String message;

  const NutritionError(this.message);

  @override
  List<Object> get props => [message];
}
