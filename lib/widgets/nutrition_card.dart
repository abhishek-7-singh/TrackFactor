import 'package:flutter/material.dart';
import '../models/food_entry.dart';

class NutritionCard extends StatelessWidget {
  final dynamic foodEntry;
  final VoidCallback? onDelete;

  const NutritionCard({
    super.key,
    required this.foodEntry,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Handle both FoodEntry objects and Map<String, dynamic>
    final name = foodEntry is Map ? foodEntry['name'] : foodEntry.name;
    final calories = foodEntry is Map ? foodEntry['calories'] : foodEntry.calories;
    final protein = foodEntry is Map ? foodEntry['protein'] : foodEntry.protein;
    final carbs = foodEntry is Map ? foodEntry['carbs'] : foodEntry.carbs;
    final fat = foodEntry is Map ? foodEntry['fat'] : foodEntry.fat;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4), // ✅ Fixed: colon instead of equals
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '${(calories ?? 0).round()}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name ?? 'Unknown Food'),
        subtitle: Text(
          'P: ${(protein ?? 0).round()}g • C: ${(carbs ?? 0).round()}g • F: ${(fat ?? 0).round()}g',
        ),
        trailing: onDelete != null
            ? IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        )
            : null,
      ),
    );
  }
}
