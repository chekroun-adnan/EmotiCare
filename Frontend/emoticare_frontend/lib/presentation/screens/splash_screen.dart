import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

import '../providers/auth_provider.dart';
import '../../core/theme/emoticare_design_system.dart';
import '../../core/widgets/animated_background.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Enhanced animated logo with gradient
              _PremiumAnimatedLogo()
                  .animate()
                  .scale(
                    delay: 200.ms,
                    duration: 1000.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(delay: 200.ms, duration: 800.ms)
                  .shimmer(
                    delay: 1500.ms,
                    duration: 2000.ms,
                    color: Colors.white.withOpacity(0.4),
                  ),
              SizedBox(height: EmotiCareDesignSystem.spacingXL),
              // Brand name with gradient text
              ShaderMask(
                shaderCallback: (bounds) => EmotiCareDesignSystem.primaryGradient
                    .createShader(bounds),
                child: Text(
                  'EmotiCare',
                  style: EmotiCareDesignSystem.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 800.ms)
                  .slideY(begin: 0.3, end: 0, delay: 600.ms, duration: 800.ms),
              SizedBox(height: EmotiCareDesignSystem.spacingMD),
              Text(
                'Your journey to emotional wellness',
                style: EmotiCareDesignSystem.textTheme.bodyLarge?.copyWith(
                  color: EmotiCareDesignSystem.neutralGray600,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0, delay: 900.ms, duration: 600.ms),
              SizedBox(height: EmotiCareDesignSystem.spacingXXXL),
              // Modern loading indicator
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: EmotiCareDesignSystem.primaryGradient,
                  boxShadow: EmotiCareDesignSystem.shadowGlow,
                ),
                child: Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 1200.ms, duration: 500.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    delay: 1200.ms,
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  ),
              SizedBox(height: EmotiCareDesignSystem.spacingLG),
              Text(
                auth.isLoading ? 'Checking session...' : 'Redirecting',
                style: EmotiCareDesignSystem.textTheme.bodyMedium?.copyWith(
                  color: EmotiCareDesignSystem.neutralGray500,
                  fontWeight: FontWeight.w500,
                ),
              )
                  .animate()
                  .fadeIn(delay: 1400.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumAnimatedLogo extends StatefulWidget {
  @override
  State<_PremiumAnimatedLogo> createState() => _PremiumAnimatedLogoState();
}

class _PremiumAnimatedLogoState extends State<_PremiumAnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _rotateController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _rotateController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathController,
        _rotateController,
        _glowController,
      ]),
      builder: (context, child) {
        final breathScale = 1.0 + (_breathController.value * 0.08);
        final glowOpacity = 0.4 + (_glowController.value * 0.3);
        final glowSize = 140 + (_breathController.value * 30);
        final rotation = _rotateController.value * 2 * math.pi * 0.1;

        return Container(
          width: glowSize,
          height: glowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: EmotiCareDesignSystem.primaryPurple.withOpacity(glowOpacity),
                blurRadius: 50 + (_breathController.value * 30),
                spreadRadius: 15,
              ),
              BoxShadow(
                color: EmotiCareDesignSystem.primaryLavender.withOpacity(glowOpacity * 0.7),
                blurRadius: 70 + (_breathController.value * 40),
                spreadRadius: 20,
              ),
            ],
          ),
          child: Transform.rotate(
            angle: rotation,
            child: Transform.scale(
              scale: breathScale,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: EmotiCareDesignSystem.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: EmotiCareDesignSystem.shadowGlow,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow ring
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                    // Heart icon
                    const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 64,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
