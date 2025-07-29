import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import '../models/exercise.dart';
import '../models/workout_session.dart';

class ExerciseRepository {
  final Dio _dio = Dio();
  static const String _exercisesBoxName = 'exercises';
  static const String _workoutsBoxName = 'workouts';

  Future<List<Exercise>> getExercises() async {
    try {
      // Try to get from local storage first
      final box = await Hive.openBox<Exercise>(_exercisesBoxName);
      if (box.values.isNotEmpty) {
        return box.values.toList();
      }

      // If empty, fetch from API (mock data for now)
      final exercises = _getMockExercises();

      // Save to local storage
      for (final exercise in exercises) {
        await box.put(exercise.id, exercise);
      }

      return exercises;
    } catch (e) {
      // Return mock data on error
      return _getMockExercises();
    }
  }

  Future<List<WorkoutSession>> getWorkoutHistory() async {
    try {
      final box = await Hive.openBox<WorkoutSession>(_workoutsBoxName);
      return box.values.toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveWorkoutSession(WorkoutSession session) async {
    try {
      final box = await Hive.openBox<WorkoutSession>(_workoutsBoxName);
      await box.put(session.id, session);
    } catch (e) {
      throw Exception('Failed to save workout session: $e');
    }
  }

  List<Exercise> _getMockExercises() {
    return [
      const Exercise(
        id: 'bench_press',
        name: 'Bench Press',
        image: 'https://via.placeholder.com/400x300/007AFF/FFFFFF?text=Bench+Press',
        target: ['Chest', 'Triceps', 'Shoulders'],
        equipment: 'Barbell',
        instructions: 'Lie on bench with feet flat on floor. Grip bar with hands slightly wider than shoulder-width. Lower bar to chest, then press up explosively.',
      ),
      const Exercise(
        id: 'deadlift',
        name: 'Deadlift',
        image: 'https://via.placeholder.com/400x300/28A745/FFFFFF?text=Deadlift',
        target: ['Hamstrings', 'Glutes', 'Lower Back'],
        equipment: 'Barbell',
        instructions: 'Stand over bar with feet hip-width apart. Bend at hips and knees to grip bar. Lift by driving hips forward and extending knees.',
      ),
      const Exercise(
        id: 'overhead_press',
        name: 'Overhead Press',
        image: 'https://via.placeholder.com/400x300/DC3545/FFFFFF?text=Overhead+Press',
        target: ['Shoulders', 'Triceps', 'Core'],
        equipment: 'Barbell',
        instructions: 'Stand with feet shoulder-width apart. Hold bar at shoulder level. Press bar straight overhead until arms are fully extended.',
      ),
      const Exercise(
        id: 'pullup',
        name: 'Pull-Up',
        image: 'https://via.placeholder.com/400x300/FF9500/FFFFFF?text=Pull+Up',
        target: ['Latissimus Dorsi', 'Biceps', 'Rhomboids'],
        equipment: 'Pull-up Bar',
        instructions: 'Hang from bar with overhand grip, hands shoulder-width apart. Pull body up until chin clears bar. Lower with control.',
      ),
      const Exercise(
        id: 'squat',
        name: 'Back Squat',
        image: 'https://via.placeholder.com/400x300/6C757D/FFFFFF?text=Back+Squat',
        target: ['Quadriceps', 'Glutes', 'Hamstrings'],
        equipment: 'Barbell',
        instructions: 'Stand with bar on upper back. Feet shoulder-width apart. Squat down by pushing hips back and bending knees. Return to standing.',
      ),
      const Exercise(
        id: 'pushup',
        name: 'Push-Up',
        image: 'https://via.placeholder.com/400x300/17A2B8/FFFFFF?text=Push+Up',
        target: ['Chest', 'Triceps', 'Core'],
        equipment: 'Bodyweight',
        instructions: 'Start in plank position. Lower body until chest nearly touches floor. Push back up to starting position.',
      ),
      const Exercise(
        id: 'row',
        name: 'Barbell Row',
        image: 'https://via.placeholder.com/400x300/6F42C1/FFFFFF?text=Barbell+Row',
        target: ['Latissimus Dorsi', 'Rhomboids', 'Biceps'],
        equipment: 'Barbell',
        instructions: 'Bend at hips with slight knee bend. Hold bar with overhand grip. Pull bar to lower chest, squeeze shoulder blades.',
      ),
      const Exercise(
        id: 'dips',
        name: 'Dips',
        image: 'https://via.placeholder.com/400x300/E83E8C/FFFFFF?text=Dips',
        target: ['Triceps', 'Chest', 'Shoulders'],
        equipment: 'Parallel Bars',
        instructions: 'Support body on parallel bars. Lower body by bending arms until shoulders are below elbows. Push back up.',
      ),
    ];
  }
}
