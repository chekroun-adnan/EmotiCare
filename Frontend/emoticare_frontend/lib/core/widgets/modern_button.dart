import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/emoticare_design_system.dart';

/// Modern animated button with gradient and hover effects
class ModernButton extends StatefulWidget {
  const ModernButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool fullWidth;

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: EmotiCareDesignSystem.durationFast,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  double get _height {
    switch (widget.size) {
      case ButtonSize.small:
        return EmotiCareDesignSystem.buttonHeightSM;
      case ButtonSize.medium:
        return EmotiCareDesignSystem.buttonHeightMD;
      case ButtonSize.large:
        return EmotiCareDesignSystem.buttonHeightLG;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return MouseRegion(
      onEnter: (_) {
        if (isEnabled) {
          setState(() => _isHovered = true);
          _scaleController.forward();
        }
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _scaleController.reverse();
      },
      child: GestureDetector(
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) => _scaleController.reverse(),
        onTapCancel: () => _scaleController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleController,
          builder: (context, child) {
            final scale = 1.0 - (_scaleController.value * 0.05);
            return Transform.scale(
              scale: scale,
              child: Container(
                width: widget.fullWidth ? double.infinity : null,
                height: _height,
                decoration: _getDecoration(),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isEnabled ? widget.onPressed : null,
                    borderRadius: BorderRadius.circular(
                      EmotiCareDesignSystem.radiusXL,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: EmotiCareDesignSystem.spacingXL,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.isLoading)
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getTextColor(),
                                ),
                              ),
                            )
                          else if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              size: 20,
                              color: _getTextColor(),
                            ),
                            SizedBox(width: EmotiCareDesignSystem.spacingSM),
                          ],
                          Text(
                            widget.label,
                            style: TextStyle(
                              color: _getTextColor(),
                              fontSize: _fontSize,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 300.ms);
  }

  BoxDecoration _getDecoration() {
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final opacity = isEnabled ? 1.0 : 0.5;

    switch (widget.variant) {
      case ButtonVariant.primary:
        return BoxDecoration(
          gradient: EmotiCareDesignSystem.primaryGradient,
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          boxShadow: _isHovered && isEnabled
              ? EmotiCareDesignSystem.shadowGlow
              : EmotiCareDesignSystem.shadowMD,
        );
      case ButtonVariant.secondary:
        return BoxDecoration(
          color: EmotiCareDesignSystem.neutralWhite,
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          border: Border.all(
            color: EmotiCareDesignSystem.primaryPurple.withOpacity(opacity),
            width: 2,
          ),
          boxShadow: _isHovered && isEnabled
              ? EmotiCareDesignSystem.shadowLG
              : EmotiCareDesignSystem.shadowSM,
        );
      case ButtonVariant.ghost:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
        );
    }
  }

  Color _getTextColor() {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return EmotiCareDesignSystem.neutralWhite;
      case ButtonVariant.secondary:
        return EmotiCareDesignSystem.primaryPurple;
      case ButtonVariant.ghost:
        return EmotiCareDesignSystem.neutralGray700;
    }
  }
}

enum ButtonVariant { primary, secondary, ghost }
enum ButtonSize { small, medium, large }

