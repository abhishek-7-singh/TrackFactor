// import 'package:dio/dio.dart';
// import '../models/food_entry.dart';
//
// class NutritionService {
//   final Dio _dio = Dio();
//   final String _baseUrl = 'https://api.api-ninjas.com/v1/nutrition';
//   final String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with actual API key
//
//   Future<List<FoodEntry>> searchFood(String query) async {
//     try {
//       final response = await _dio.get(
//         _baseUrl,
//         queryParameters: {'query': query},
//         options: Options(
//           headers: {'X-Api-Key': _apiKey},
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data;
//         return data.map((json) => FoodEntry.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to fetch nutrition data');
//       }
//     } catch (e) {
//       throw Exception('Error searching food: $e');
//     }
//   }
// }

import 'package:dio/dio.dart';
import '../models/food_entry.dart';
import '../utils/constants.dart'; // ✅ Import constants

class NutritionService {
  final Dio _dio = Dio();

  Future<List<FoodEntry>> searchFood(String query) async {
    try {
      final response = await _dio.get(
        AppConstants.nutritionApiUrl, // ✅ Use from constants
        queryParameters: {'query': query},
        options: Options(
          headers: {'X-Api-Key': AppConstants.nutritionApiKey}, // ✅ Use from constants
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => FoodEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch nutrition data');
      }
    } catch (e) {
      throw Exception('Error searching food: $e');
    }
  }
}

