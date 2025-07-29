import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/exercise.dart';
import '../blocs/workout/workout_bloc.dart';
import '../blocs/workout/workout_event.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const WorkoutDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _sets = 3;
  int _reps = 10;
  double _weight = 50.0;
  bool _isAssisted = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'exercise_${widget.exercise.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: widget.exercise.image,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Target Muscles',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: widget.exercise.target
                      .map((muscle) => Chip(label: Text(muscle)))
                      .toList(),
                ),
                const SizedBox(height: 24),
                Text(
                  'Equipment',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.exercise.equipment,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (widget.exercise.instructions != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Instructions',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.exercise.instructions!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 32),
                _buildWorkoutLogger(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutLogger() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log Your Set',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildSlider(
              label: 'Sets',
              value: _sets.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) => setState(() => _sets = value.round()),
            ),
            _buildSlider(
              label: 'Reps',
              value: _reps.toDouble(),
              min: 1,
              max: 20,
              divisions: 19,
              onChanged: (value) => setState(() => _reps = value.round()),
            ),
            _buildSlider(
              label: 'Weight (kg)',
              value: _weight,
              min: 0,
              max: 200,
              divisions: 200,
              onChanged: (value) => setState(() => _weight = value),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Assisted Exercise'),
              subtitle: const Text('Check if this is an assisted exercise'),
              value: _isAssisted,
              onChanged: (value) => setState(() => _isAssisted = value),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logExercise,
                icon: const Icon(Icons.save),
                label: const Text('Log Set'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              label.contains('Weight') ? '${value.toStringAsFixed(1)} kg' : value.round().toString(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _logExercise() {
    context.read<WorkoutBloc>().add(
      LogExercise(
        exercise: widget.exercise,
        sets: _sets,
        reps: _reps,
        weight: _weight,
        isAssisted: _isAssisted,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Set logged successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }
}
