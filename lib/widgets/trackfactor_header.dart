import 'package:flutter/material.dart';

class TrackFactorHeader extends StatefulWidget {
  final double collapsedHeight;
  final double expandedHeight;
  final bool isCollapsed;

  const TrackFactorHeader({
    super.key,
    this.collapsedHeight = 80,
    this.expandedHeight = 160,
    required this.isCollapsed,
  });

  @override
  State<TrackFactorHeader> createState() => _TrackFactorHeaderState();
}

class _TrackFactorHeaderState extends State<TrackFactorHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Check if widget is still mounted before starting animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.isCollapsed ? widget.collapsedHeight : widget.expandedHeight,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
        ),
        child: Stack(
          children: [
            // Subtle animated accent line
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF007AFF).withOpacity(0.6),
                          Colors.transparent,
                        ],
                        stops: [
                          (_controller.value - 0.1).clamp(0.0, 1.0),
                          _controller.value,
                          (_controller.value + 0.1).clamp(0.0, 1.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Clean logo
                  Container(
                    width: widget.isCollapsed ? 32 : 48,
                    height: widget.isCollapsed ? 32 : 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF007AFF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.timeline,
                      color: Colors.white,
                      size: widget.isCollapsed ? 18 : 24,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Clean typography
                  Text(
                    'TrackFactor',
                    style: TextStyle(
                      fontSize: widget.isCollapsed ? 16 : 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),

                  if (!widget.isCollapsed) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Professional Fitness Tracking',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
