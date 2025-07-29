import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/trackfactor_header.dart';
import '../blocs/workout/workout_bloc.dart';
import '../blocs/workout/workout_event.dart';
import 'workout_screen.dart';
import 'nutrition_screen.dart';
import 'steps_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _isHeaderCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  static const List<Widget> _pages = [
    WorkoutScreen(),
    NutritionScreen(),
    StepsScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);

    // Load exercises after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          context.read<WorkoutBloc>().add(LoadExercises());
        } catch (e) {
          print('Failed to load exercises: $e');
        }
      }
    });
  }

  void _onScroll() {
    if (!mounted) return;

    final isCollapsed = _scrollController.hasClients &&
        _scrollController.offset > 80;

    if (isCollapsed != _isHeaderCollapsed && mounted) {
      setState(() {
        _isHeaderCollapsed = isCollapsed;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 160,
              collapsedHeight: 80,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: TrackFactorHeader(
                isCollapsed: _isHeaderCollapsed,
              ),
            ),
          ];
        },
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
        ),
      ),
      bottomNavigationBar: _buildMinimalistNavBar(),
    );
  }

  Widget _buildMinimalistNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(6, 4, 6, 2), // ✅ Further reduced bottom margin
        constraints: const BoxConstraints(
          maxHeight: 72, // ✅ Strict height constraint
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2), // ✅ Minimal padding
          child: IntrinsicHeight( // ✅ Ensures consistent height
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center, // ✅ Center alignment
              children: [
                Expanded(child: _buildNavItem(Icons.fitness_center_outlined, Icons.fitness_center, 'Workout', 0)),
                Expanded(child: _buildNavItem(Icons.restaurant_outlined, Icons.restaurant, 'Nutrition', 1)),
                Expanded(child: _buildNavItem(Icons.directions_walk_outlined, Icons.directions_walk, 'Steps', 2)),
                Expanded(child: _buildNavItem(Icons.show_chart_outlined, Icons.show_chart, 'Progress', 3)),
                Expanded(child: _buildNavItem(Icons.settings_outlined, Icons.settings, 'Settings', 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() => _selectedIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // ✅ Minimal padding
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF007AFF).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected
                  ? const Color(0xFF007AFF)
                  : (isDark ? Colors.white.withOpacity(0.6) : const Color(0xFF6C757D)),
              size: 16, // ✅ Smaller icon size
            ),
            const SizedBox(height: 1), // ✅ Minimal spacing
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 8, // ✅ Smaller font size
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF007AFF)
                      : (isDark ? Colors.white.withOpacity(0.6) : const Color(0xFF6C757D)),
                  letterSpacing: 0.0, // ✅ No letter spacing
                  height: 1.0, // ✅ Tight line height
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
