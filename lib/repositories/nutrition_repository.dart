import 'package:hive/hive.dart';
import '../models/food_entry.dart';
import '../services/nutrition_service.dart';

class NutritionRepository {
  final NutritionService nutritionService;
  static const String _foodBoxName = 'food_entries';

  NutritionRepository(this.nutritionService);

  Future<Box<FoodEntry>> get _foodBox async {
    if (!Hive.isBoxOpen(_foodBoxName)) {
      return await Hive.openBox<FoodEntry>(_foodBoxName);
    }
    return Hive.box<FoodEntry>(_foodBoxName);
  }

  Future<List<FoodEntry>> getFoodEntries() async {
    final box = await _foodBox;
    final entries = box.values.toList();
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  Future<List<FoodEntry>> searchFood(String query) async {
    return await nutritionService.searchFood(query);
  }

  Future<void> addFoodEntry(FoodEntry foodEntry) async {
    final box = await _foodBox;
    await box.put(foodEntry.id, foodEntry);
  }

  Future<void> deleteFoodEntry(String id) async {
    final box = await _foodBox;
    await box.delete(id);
  }

  Future<List<FoodEntry>> getTodaysFoodEntries() async {
    final box = await _foodBox;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return box.values
        .where((entry) =>
    entry.timestamp.isAfter(startOfDay) &&
        entry.timestamp.isBefore(endOfDay))
        .toList();
  }
}
