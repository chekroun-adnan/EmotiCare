import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// Animated gradient background with floating shapes
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    super.key,
    this.child,
    this.colors,
  });

  final Widget? child;
  final List<Color>? colors;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ?? [
      AppTheme.softPurple.withOpacity(0.12),
      AppTheme.lavender.withOpacity(0.10),
      AppTheme.lightPink.withOpacity(0.08),
      AppTheme.softBlue.withOpacity(0.06),
    ];

    return Stack(
      children: [
        // Animated gradient background
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(
                    math.sin(_controller.value * 2 * math.pi) * 0.5,
                    math.cos(_controller.value * 2 * math.pi) * 0.5,
                  ),
                  end: Alignment(
                    -math.sin(_controller.value * 2 * math.pi) * 0.5,
                    -math.cos(_controller.value * 2 * math.pi) * 0.5,
                  ),
                  colors: colors,
                ),
              ),
            );
          },
        ),
        // Floating blobs
        ...List.generate(5, (index) => _FloatingBlob(index: index)),
        // Child content
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _FloatingBlob extends StatefulWidget {
  const _FloatingBlob({required this.index});

  final int index;

  @override
  State<_FloatingBlob> createState() => _FloatingBlobState();
}

class _FloatingBlobState extends State<_FloatingBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 3000 + _random.nextInt(2000) + widget.index * 500,
      ),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = [
      AppTheme.softPurple.withOpacity(0.08),
      AppTheme.lavender.withOpacity(0.06),
      AppTheme.lightPink.withOpacity(0.05),
      AppTheme.softBlue.withOpacity(0.04),
    ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = _controller.value * 50;
        final scale = 0.5 + (_controller.value * 0.3);
        final x = (widget.index * 150.0 + offset) % size.width;
        final y = (widget.index * 200.0 + offset * 0.7) % size.height;

        return Positioned(
          left: x,
          top: y,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 200 + widget.index * 50,
              height: 200 + widget.index * 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors[widget.index % colors.length],
                    colors[widget.index % colors.length].withOpacity(0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors[widget.index % colors.length],
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

