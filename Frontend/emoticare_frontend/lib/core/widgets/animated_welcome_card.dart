import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// Enhanced welcome card with breathing gradient and animated elements
class AnimatedWelcomeCard extends StatefulWidget {
  const AnimatedWelcomeCard({
    super.key,
    required this.name,
    this.onTap,
  });

  final String name;
  final VoidCallback? onTap;

  @override
  State<AnimatedWelcomeCard> createState() => _AnimatedWelcomeCardState();
}

class _AnimatedWelcomeCardState extends State<AnimatedWelcomeCard>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_breathingController, _floatController]),
        builder: (context, child) {
          final breathingScale = 1.0 + (_breathingController.value * 0.02);
          final floatOffset = _floatController.value * 8;

          return Transform.scale(
            scale: breathingScale,
            child: Transform.translate(
              offset: Offset(0, floatOffset),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.softPurple,
                      AppTheme.lavender,
                      AppTheme.lightPink.withOpacity(0.8),
                    ],
                    stops: [
                      0.0,
                      0.5 + (_breathingController.value * 0.1),
                      1.0,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.softPurple.withOpacity(
                        0.3 + (_breathingController.value * 0.2),
                      ),
                      blurRadius: 30 + (_breathingController.value * 10),
                      spreadRadius: 5,
                      offset: Offset(0, 15 + (_breathingController.value * 5)),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Animated avatar with glow ring
                    _AnimatedAvatar(
                      controller: _breathingController,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideX(begin: -0.2, end: 0),
                          const SizedBox(height: 6),
                          Text(
                            widget.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                          )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 600.ms)
                              .slideX(begin: -0.2, end: 0),
                        ],
                      ),
                    ),
                    // Floating sun/moon icon
                    _FloatingIcon(controller: _floatController),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedAvatar extends StatelessWidget {
  const _AnimatedAvatar({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final glowSize = 70 + (controller.value * 8);
        return Container(
          width: glowSize,
          height: glowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3 + (controller.value * 0.2)),
                blurRadius: 20 + (controller.value * 10),
                spreadRadius: 5,
              ),
            ],
          ),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.5,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        );
      },
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final rotation = controller.value * 0.1;
        final float = controller.value * 6;
        return Transform.rotate(
          angle: rotation,
          child: Transform.translate(
            offset: Offset(0, float),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.wb_sunny_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        );
      },
    );
  }
}

