import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/workout/workout_bloc.dart';
import '../blocs/workout/workout_event.dart';
import '../blocs/workout/workout_state.dart';
import '../widgets/animated_exercise_card.dart';
import 'workout_detail_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(LoadExercises());

    _listController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize with empty list, will be updated when exercises load
    _slideAnimations = [];
  }

  void _initializeAnimations(int itemCount) {
    _slideAnimations = List.generate(
      itemCount,
          (index) => Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _listController,
        curve: Interval(
          index * 0.1,
          (index * 0.1 + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutBack,
        ),
      )),
    );
    _listController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
        actions: [
          BlocBuilder<WorkoutBloc, WorkoutState>(
            builder: (context, state) {
              if (state is WorkoutInProgress) {
                return TextButton(
                  onPressed: () {
                    context.read<WorkoutBloc>().add(const CompleteWorkout());
                  },
                  child: const Text('Finish'),
                );
              }
              return TextButton(
                onPressed: () {
                  context.read<WorkoutBloc>().add(StartWorkout());
                },
                child: const Text('Start'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorkoutError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WorkoutBloc>().add(LoadExercises());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is WorkoutLoaded) {
            // Initialize animations when exercises are loaded
            if (_slideAnimations.length != state.exercises.length) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _initializeAnimations(state.exercises.length);
              });
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: state.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = state.exercises[index];

                  return _slideAnimations.length > index
                      ? SlideTransition(
                    position: _slideAnimations[index],
                    child: AnimatedExerciseCard(
                      exercise: exercise,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDetailScreen(
                              exercise: exercise,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : AnimatedExerciseCard(
                    exercise: exercise,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutDetailScreen(
                            exercise: exercise,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const Center(child: Text('No exercises available'));
        },
      ),
    );
  }
}
