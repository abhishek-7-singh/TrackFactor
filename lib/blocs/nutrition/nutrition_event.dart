import 'package:equatable/equatable.dart';
import '../../models/food_entry.dart';

abstract class NutritionEvent extends Equatable {
  const NutritionEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodEntries extends NutritionEvent {}

class SearchFood extends NutritionEvent {
  final String query;

  const SearchFood(this.query);

  @override
  List<Object> get props => [query];
}

class AddFoodEntry extends NutritionEvent {
  final FoodEntry foodEntry;

  const AddFoodEntry(this.foodEntry);

  @override
  List<Object> get props => [foodEntry];
}

class DeleteFoodEntry extends NutritionEvent {
  final String id;

  const DeleteFoodEntry(this.id);

  @override
  List<Object> get props => [id];
}
