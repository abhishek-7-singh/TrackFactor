// // lib/utils/constants.dart
//
// class AppConstants {
//   // ── API CONFIG ────────────────────────────────────────────────────────────────
//   static const String nutritionApiKey  = 'YOUR_API_NINJAS_KEY_HERE';
//   static const String nutritionApiUrl  = 'https://api.api-ninjas.com/v1/nutrition';
//
//   // ── DEFAULT GOALS ─────────────────────────────────────────────────────────────
//   static const int    defaultStepGoal      = 10000;
//   static const int    defaultCalorieGoal   = 2000;
//   static const int    defaultProteinGoal   = 150;   // g / day
//
//   // ── ANIMATION DURATIONS ──────────────────────────────────────────────────────
//   static const Duration shortAnimation  = Duration(milliseconds: 300);
//   static const Duration mediumAnimation = Duration(milliseconds: 600);
//   static const Duration longAnimation   = Duration(milliseconds: 900);
//
//   // ── PROGRESSIVE-OVERLOAD LIMITS ───────────────────────────────────────────────
//   static const double progressionRate = 0.025;   // 2.5 %
//   static const int    minReps         = 1;
//   static const int    maxReps         = 20;
//   static const double minWeight       = 0.0;     // kg
//   static const double maxWeight       = 300.0;   // kg
//
//   // ── HIVE TYPE IDs (KEEP IN SYNC WITH *.g.dart) ───────────────────────────────
//   static const int hiveTypeExercise        = 0;
//   static const int hiveTypeWorkoutSession  = 1;
//   static const int hiveTypeExerciseSet     = 2;
//   static const int hiveTypeFoodEntry       = 3;
//   static const int hiveTypeStepData        = 4;
//
//   // ── HIVE BOX NAMES ────────────────────────────────────────────────────────────
//   static const String boxExercises     = 'exercises';
//   static const String boxWorkouts      = 'workouts';
//   static const String boxFoodEntries   = 'food_entries';
//   static const String boxStepData      = 'step_data';
//
//   // ── SHARED-PREFS KEYS ────────────────────────────────────────────────────────
//   static const String prefThemeMode    = 'pref_theme_mode';     // light / dark / system
//   static const String prefUnitSystem   = 'pref_unit_system';    // metric / imperial
//   static const String prefStepGoal     = 'pref_step_goal';
//   static const String prefCalorieGoal  = 'pref_calorie_goal';
//   static const String prefProteinGoal  = 'pref_protein_goal';
//
//   // ── DATE / TIME ───────────────────────────────────────────────────────────────
//   static const String dateFormat       = 'yyyy-MM-dd';          // ISO-like for storage
//
//   // ── EXTERNAL LINKS ───────────────────────────────────────────────────────────
//   static const String privacyPolicyUrl     = 'https://trackfactor.app/privacy';
//   static const String termsOfServiceUrl    = 'https://trackfactor.app/terms';
//
//   // ── ASSET PATHS ──────────────────────────────────────────────────────────────
//   static const String lottieSuccess    = 'assets/lottie/success.json';
//   static const String lottieLoading    = 'assets/lottie/loading.json';
//   static const String lottieWorkout    = 'assets/lottie/workout.json';
// }
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // ── API CONFIG ────────────────────────────────────────────────────────────────
  static String get nutritionApiKey => dotenv.env['API_NINJAS_KEY'] ?? '';
  static String get nutritionApiUrl => dotenv.env['NUTRITION_API_URL'] ?? 'https://api.api-ninjas.com/v1/nutrition';

  // Add other API keys as needed
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';

  // ── DEFAULT GOALS ─────────────────────────────────────────────────────────────
  static const int    defaultStepGoal      = 10000;
  static const int    defaultCalorieGoal   = 2000;
  static const int    defaultProteinGoal   = 150;

  // ── ANIMATION DURATIONS ──────────────────────────────────────────────────────
  static const Duration shortAnimation  = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 600);
  static const Duration longAnimation   = Duration(milliseconds: 900);

  // ── PROGRESSIVE-OVERLOAD LIMITS ───────────────────────────────────────────────
  static const double progressionRate = 0.025;
  static const int    minReps         = 1;
  static const int    maxReps         = 20;
  static const double minWeight       = 0.0;
  static const double maxWeight       = 300.0;

  // ── HIVE TYPE IDs ─────────────────────────────────────────────────────────────
  static const int hiveTypeExercise        = 0;
  static const int hiveTypeWorkoutSession  = 1;
  static const int hiveTypeExerciseSet     = 2;
  static const int hiveTypeFoodEntry       = 3;
  static const int hiveTypeStepData        = 4;

  // ── HIVE BOX NAMES ────────────────────────────────────────────────────────────
  static const String boxExercises     = 'exercises';
  static const String boxWorkouts      = 'workouts';
  static const String boxFoodEntries   = 'food_entries';
  static const String boxStepData      = 'step_data';

  // ── SHARED-PREFS KEYS ────────────────────────────────────────────────────────
  static const String prefThemeMode    = 'pref_theme_mode';
  static const String prefUnitSystem   = 'pref_unit_system';
  static const String prefStepGoal     = 'pref_step_goal';
  static const String prefCalorieGoal  = 'pref_calorie_goal';
  static const String prefProteinGoal  = 'pref_protein_goal';

  // ── DATE / TIME ───────────────────────────────────────────────────────────────
  static const String dateFormat       = 'yyyy-MM-dd';

  // ── EXTERNAL LINKS ───────────────────────────────────────────────────────────
  static const String privacyPolicyUrl     = 'https://trackfactor.app/privacy';
  static const String termsOfServiceUrl    = 'https://trackfactor.app/terms';

  // ── ASSET PATHS ──────────────────────────────────────────────────────────────
  static const String lottieSuccess    = 'assets/lottie/success.json';
  static const String lottieLoading    = 'assets/lottie/loading.json';
  static const String lottieWorkout    = 'assets/lottie/workout.json';

  // ── APP CONFIG ────────────────────────────────────────────────────────────────
  static String get appName => dotenv.env['APP_NAME'] ?? 'TrackFactor';
  static bool get debugMode => dotenv.env['DEBUG_MODE'] == 'true';
}
