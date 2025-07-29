import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/nutrition_repository.dart';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final NutritionRepository nutritionRepository;

  NutritionBloc({required this.nutritionRepository}) : super(NutritionInitial()) {
    on<LoadFoodEntries>(_onLoadFoodEntries);
    on<SearchFood>(_onSearchFood);
    on<AddFoodEntry>(_onAddFoodEntry);
    on<DeleteFoodEntry>(_onDeleteFoodEntry);
  }

  Future<void> _onLoadFoodEntries(LoadFoodEntries event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());
    try {
      final foodEntries = await nutritionRepository.getFoodEntries();
      final totals = _calculateTotals(foodEntries);
      emit(NutritionLoaded(
        foodEntries: foodEntries,
        totalCalories: totals['calories']!,
        totalProtein: totals['protein']!,
        totalCarbs: totals['carbs']!,
        totalFat: totals['fat']!,
      ));
    } catch (e) {
      emit(NutritionError('Failed to load food entries: $e'));
    }
  }

  Future<void> _onSearchFood(SearchFood event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());
    try {
      final results = await nutritionRepository.searchFood(event.query);
      emit(FoodSearchResults(results));
    } catch (e) {
      emit(NutritionError('Failed to search food: $e'));
    }
  }

  Future<void> _onAddFoodEntry(AddFoodEntry event, Emitter<NutritionState> emit) async {
    try {
      await nutritionRepository.addFoodEntry(event.foodEntry);
      add(LoadFoodEntries());
    } catch (e) {
      emit(NutritionError('Failed to add food entry: $e'));
    }
  }

  Future<void> _onDeleteFoodEntry(DeleteFoodEntry event, Emitter<NutritionState> emit) async {
    try {
      await nutritionRepository.deleteFoodEntry(event.id);
      add(LoadFoodEntries());
    } catch (e) {
      emit(NutritionError('Failed to delete food entry: $e'));
    }
  }

  Map<String, double> _calculateTotals(List<dynamic> foodEntries) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (final entry in foodEntries) {
      if (entry is Map<String, dynamic>) {
        totalCalories += (entry['calories'] ?? 0).toDouble();
        totalProtein += (entry['protein'] ?? 0).toDouble();
        totalCarbs += (entry['carbs'] ?? 0).toDouble();
        totalFat += (entry['fat'] ?? 0).toDouble();
      }
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
    };
  }
}
