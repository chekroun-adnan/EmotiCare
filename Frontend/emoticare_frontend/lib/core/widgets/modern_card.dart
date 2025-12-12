import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/emoticare_design_system.dart';

/// Modern glassmorphic card with animations
class ModernCard extends StatefulWidget {
  const ModernCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.gradient,
    this.glowColor,
    this.delay = Duration.zero,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Gradient? gradient;
  final Color? glowColor;
  final Duration delay;

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: EmotiCareDesignSystem.durationNormal,
          curve: EmotiCareDesignSystem.curveDefault,
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.02 : 1.0),
          margin: widget.margin ?? EdgeInsets.all(EmotiCareDesignSystem.spacingMD),
          padding: widget.padding ?? EdgeInsets.all(EmotiCareDesignSystem.spacingLG),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            color: widget.gradient == null
                ? EmotiCareDesignSystem.neutralWhite
                : null,
            borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXXL),
            border: Border.all(
              color: EmotiCareDesignSystem.neutralGray200.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              if (widget.glowColor != null)
                BoxShadow(
                  color: widget.glowColor!.withOpacity(
                    0.2 + (_glowController.value * 0.15),
                  ),
                  blurRadius: 25 + (_glowController.value * 10),
                  spreadRadius: 2,
                ),
              BoxShadow(
                color: EmotiCareDesignSystem.neutralGray900.withOpacity(
                  _isHovered ? 0.12 : 0.08,
                ),
                blurRadius: _isHovered ? 24 : 16,
                offset: Offset(0, _isHovered ? 12 : 8),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    )
        .animate()
        .fadeIn(delay: widget.delay, duration: 500.ms)
        .slideY(
          begin: 0.3,
          end: 0,
          delay: widget.delay,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          delay: widget.delay,
          duration: 500.ms,
        );
  }
}

