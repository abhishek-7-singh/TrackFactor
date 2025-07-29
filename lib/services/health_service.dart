import 'package:health/health.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  static const List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
  ];

  Future<bool> requestPermissions() async {
    try {
      bool requested = await Health().requestAuthorization(_dataTypes);
      return requested;
    } catch (e) {
      print('Error requesting health permissions: $e');
      return false;
    }
  }

  Future<int?> getTodaysSteps() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        startOfDay,
        now,
        [HealthDataType.STEPS],
      );

      if (healthData.isNotEmpty) {
        int totalSteps = 0;
        for (final dataPoint in healthData) {
          totalSteps += (dataPoint.value as NumericHealthValue).numericValue.toInt();
        }
        return totalSteps;
      }
    } catch (e) {
      print('Error getting steps from Health: $e');
    }
    return null;
  }

  Future<bool> writeWorkoutData({
    required DateTime startTime,
    required DateTime endTime,
    required int calories,
  }) async {
    try {
      bool success = await Health().writeHealthData(
        value: calories.toDouble(),
        type: HealthDataType.ACTIVE_ENERGY_BURNED,
        startTime: startTime,
        endTime: endTime,
      );
      return success;
    } catch (e) {
      print('Error writing workout data: $e');
      return false;
    }
  }

  Future<double?> getTodaysWeight() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        startOfDay,
        now,
        [HealthDataType.WEIGHT],
      );

      if (healthData.isNotEmpty) {
        // Get the most recent weight entry
        final latestWeight = healthData.last;
        return (latestWeight.value as NumericHealthValue).numericValue.toDouble(); // ✅ Fixed: added .toDouble()
      }
    } catch (e) {
      print('Error getting weight from Health: $e');
    }
    return null;
  }

  Future<double?> getTodaysDistance() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        startOfDay,
        now,
        [HealthDataType.DISTANCE_WALKING_RUNNING],
      );

      if (healthData.isNotEmpty) {
        double totalDistance = 0;
        for (final dataPoint in healthData) {
          totalDistance += (dataPoint.value as NumericHealthValue).numericValue.toDouble(); // ✅ Fixed: added .toDouble()
        }
        return totalDistance;
      }
    } catch (e) {
      print('Error getting distance from Health: $e');
    }
    return null;
  }

  Future<bool> writeWeightData({
    required DateTime timestamp,
    required double weight,
  }) async {
    try {
      bool success = await Health().writeHealthData(
        value: weight,
        type: HealthDataType.WEIGHT,
        startTime: timestamp,
        endTime: timestamp,
      );
      return success;
    } catch (e) {
      print('Error writing weight data: $e');
      return false;
    }
  }

  Future<bool> writeStepsData({
    required DateTime startTime,
    required DateTime endTime,
    required int steps,
  }) async {
    try {
      bool success = await Health().writeHealthData(
        value: steps.toDouble(),
        type: HealthDataType.STEPS,
        startTime: startTime,
        endTime: endTime,
      );
      return success;
    } catch (e) {
      print('Error writing steps data: $e');
      return false;
    }
  }
}
