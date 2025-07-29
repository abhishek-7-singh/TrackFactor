import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/observer.dart';
import 'blocs/workout/workout_bloc.dart';
import 'blocs/nutrition/nutrition_bloc.dart';
import 'blocs/steps/steps_bloc.dart';
import 'blocs/steps/steps_event.dart';  // ✅ Add this import
import 'repositories/exercise_repository.dart';
import 'repositories/nutrition_repository.dart';
import 'repositories/steps_repository.dart';
import 'services/nutrition_service.dart';
import 'services/pedometer_service.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'models/exercise.dart';
import 'models/workout_session.dart';
import 'models/food_entry.dart';
import 'models/step_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Hive
  await Hive.initFlutter();

  // Register all Hive type adapters
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(WorkoutSessionAdapter());
  Hive.registerAdapter(ExerciseSetAdapter());
  Hive.registerAdapter(FoodEntryAdapter());
  Hive.registerAdapter(StepDataAdapter());

  // Request permissions
  await _requestPermissions();

  // Set up BLoC observer
  Bloc.observer = AppBlocObserver();

  runApp(const TrackFactorApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.activityRecognition,
    Permission.sensors,
  ].request();
}

class TrackFactorApp extends StatelessWidget {
  const TrackFactorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ExerciseRepository>(
          create: (context) => ExerciseRepository(),
        ),
        RepositoryProvider<NutritionRepository>(
          create: (context) => NutritionRepository(NutritionService()),
        ),
        RepositoryProvider<StepsRepository>(
          create: (context) => StepsRepository(PedometerService()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WorkoutBloc>(
            create: (context) => WorkoutBloc(
              exerciseRepository: context.read<ExerciseRepository>(),
            ),
          ),
          BlocProvider<NutritionBloc>(
            create: (context) => NutritionBloc(
              nutritionRepository: context.read<NutritionRepository>(),
            ),
          ),
          BlocProvider<StepsBloc>(
            create: (context) => StepsBloc(
              stepsRepository: context.read<StepsRepository>(),
            )..add(StartStepTracking()), // ✅ Now this will work
          ),
        ],
        child: MaterialApp(
          title: 'TrackFactor',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
