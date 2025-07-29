import 'dart:math';
import 'package:intl/intl.dart';

class Helpers {
  static String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);
    return '${timestamp}_$random';
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  static double calculateProgressiveOverload({
    required double currentWeight,
    required int currentReps,
    required int targetReps,
    double progressionRate = 0.025,
  }) {
    final baseWeight = currentWeight * (1 + progressionRate);
    final repAdjustment = (targetReps - currentReps) * 0.025;
    return baseWeight * (1 + repAdjustment);
  }

  static double calculateCaloriesBurned(int steps) {
    return steps * 0.04;
  }

  static String formatWeight(double weight, {bool imperial = false}) {
    if (imperial) {
      final pounds = weight * 2.20462;
      return '${pounds.toStringAsFixed(1)} lbs';
    }
    return '${weight.toStringAsFixed(1)} kg';
  }

  static String formatDistance(double distance, {bool imperial = false}) {
    if (imperial) {
      final miles = distance * 0.621371;
      return '${miles.toStringAsFixed(2)} mi';
    }
    return '${distance.toStringAsFixed(2)} km';
  }
}
