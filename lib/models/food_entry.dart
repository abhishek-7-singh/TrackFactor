import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'food_entry.g.dart';

@HiveType(typeId: 3)
class FoodEntry extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final double calories;

  @HiveField(4)
  final double protein;

  @HiveField(5)
  final double carbs;

  @HiveField(6)
  final double fat;

  @HiveField(7)
  final double servingSize;

  const FoodEntry({
    required this.id,
    required this.name,
    required this.timestamp,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
  });

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['name']?.replaceAll(' ', '_') ?? '',
      name: json['name'] ?? '',
      timestamp: DateTime.now(),
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein_g'] ?? 0).toDouble(),
      carbs: (json['carbohydrates_total_g'] ?? 0).toDouble(),
      fat: (json['fat_total_g'] ?? 0).toDouble(),
      servingSize: (json['serving_size_g'] ?? 100).toDouble(),
    );
  }

  @override
  List<Object> get props => [id, name, timestamp, calories, protein, carbs, fat, servingSize];
}
