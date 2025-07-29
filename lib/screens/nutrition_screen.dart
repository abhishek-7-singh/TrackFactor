import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart';
import '../blocs/nutrition/nutrition_bloc.dart';
import '../blocs/nutrition/nutrition_event.dart';
import '../blocs/nutrition/nutrition_state.dart';
import '../widgets/nutrition_card.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    context.read<NutritionBloc>().add(LoadFoodEntries());

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search for food (e.g., "2 eggs, banana")',
              leading: const Icon(Icons.search),
              trailing: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ],
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context.read<NutritionBloc>().add(SearchFood(query));
                }
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<NutritionBloc, NutritionState>(
        builder: (context, state) {
          if (state is NutritionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NutritionError) {
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
                      context.read<NutritionBloc>().add(LoadFoodEntries());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FoodSearchResults) {
            return _buildSearchResults(state.results);
          }

          if (state is NutritionLoaded) {
            return _buildNutritionDashboard(state);
          }

          return const Center(child: Text('Start by searching for food'));
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () => _showQuickAddDialog(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildNutritionDashboard(NutritionLoaded state) {
    return Column(
      children: [
        _buildNutritionSummary(state),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.foodEntries.length,
            itemBuilder: (context, index) {
              final entry = state.foodEntries[index];
              return OpenContainer(
                closedElevation: 0,
                transitionType: ContainerTransitionType.fadeThrough,
                openBuilder: (context, action) => _buildFoodDetail(entry),
                closedBuilder: (context, action) => NutritionCard(
                  foodEntry: entry,
                  onDelete: () {
                    context.read<NutritionBloc>().add(DeleteFoodEntry(entry.id));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionSummary(NutritionLoaded state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Today\'s Nutrition',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNutritionStat('Calories', state.totalCalories.round(), 'kcal'),
              _buildNutritionStat('Protein', state.totalProtein.round(), 'g'),
              _buildNutritionStat('Carbs', state.totalCarbs.round(), 'g'),
              _buildNutritionStat('Fat', state.totalFat.round(), 'g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionStat(String label, int value, String unit) {
    return Column(
      children: [
        Text(
          '$value',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('$label ($unit)'),
      ],
    );
  }

  Widget _buildSearchResults(List<dynamic> results) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return Card(
          child: ListTile(
            title: Text(result['name'] ?? 'Unknown food'),
            subtitle: Text('${result['calories'] ?? 0} calories'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Add the food entry
                context.read<NutritionBloc>().add(AddFoodEntry(result));
                context.read<NutritionBloc>().add(LoadFoodEntries());
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFoodDetail(dynamic entry) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry['name'] ?? 'Food Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Calories', '${entry['calories'] ?? 0} kcal'),
            _buildDetailRow('Protein', '${entry['protein'] ?? 0} g'),
            _buildDetailRow('Carbohydrates', '${entry['carbs'] ?? 0} g'),
            _buildDetailRow('Fat', '${entry['fat'] ?? 0} g'),
            _buildDetailRow('Serving Size', '${entry['servingSize'] ?? 100} g'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
    );
  }

  void _showQuickAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Add Food'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter food description',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              context.read<NutritionBloc>().add(SearchFood(value));
            }
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
